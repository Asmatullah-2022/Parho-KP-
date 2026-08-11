// Development helper: package, checksum, and sign a content package, then emit
// a catalog manifest entry.
//
//   PARHO_PRIVATE_KEY=<base64 seed> \
//     dart run tool/sign_package.dart \
//       --dir build/packages/grade5_math_ur_v1 \
//       --out build/packages/grade5_math_ur_v1.zip \
//       --package-id grade5_math_ur_v1 --grade 5 --subject math \
//       --language ur --version 1 \
//       --url https://cdn.example.org/parho-kp/grade5_math_ur_v1.zip
//
// The input --dir must contain the package layout:
//   manifest.json, content/{subjects,units,lessons,questions}.json,
//   optional audio/ and images/.
//
// SECURITY: the private key is read from the PARHO_PRIVATE_KEY environment
// variable only. It is NEVER read from source, committed, or logged. Run this on
// a secure signing machine; keep the private key in a secret manager.
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  final opts = _parseArgs(args);
  final dir = Directory(opts['dir'] ?? '');
  if (!dir.existsSync()) {
    _fail('Package directory not found: ${opts['dir']}');
  }

  final privateB64 = Platform.environment['PARHO_PRIVATE_KEY'];
  if (privateB64 == null || privateB64.isEmpty) {
    _fail('Set PARHO_PRIVATE_KEY (base64 Ed25519 seed) in the environment.');
  }

  // 1) Zip the package directory (stable, relative paths).
  final archive = Archive();
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is! File) continue;
    final rel = p.relative(entity.path, from: dir.path).replaceAll('\\', '/');
    final bytes = entity.readAsBytesSync();
    archive.addFile(ArchiveFile(rel, bytes.length, bytes));
  }
  final zipBytes = ZipEncoder().encode(archive)!;

  final outPath = opts['out'] ?? '${opts['package-id']}.zip';
  File(outPath).writeAsBytesSync(zipBytes);

  // 2) SHA-256 checksum.
  final sha = sha256.convert(zipBytes).toString();

  // 3) Ed25519 signature over the archive bytes.
  final algorithm = Ed25519();
  final seed = base64Decode(privateB64.trim());
  final keyPair = await algorithm.newKeyPairFromSeed(seed);
  final signature = await algorithm.sign(zipBytes, keyPair: keyPair);
  final sig = base64Encode(signature.bytes);

  final entry = {
    'packageId': opts['package-id'],
    'grade': int.tryParse(opts['grade'] ?? '0') ?? 0,
    'subject': opts['subject'] ?? '',
    'language': opts['language'] ?? '',
    'version': opts['version'] ?? '1',
    'contentVersion': int.tryParse(opts['version'] ?? '1') ?? 1,
    'sizeBytes': zipBytes.length,
    'downloadUrl': opts['url'] ?? '',
    'sha256': sha,
    'signature': sig,
    'minimumAppVersion': opts['min-app'] ?? '1.0.0',
  };

  // ignore: avoid_print
  print('Wrote $outPath (${zipBytes.length} bytes)');
  // ignore: avoid_print
  print('Manifest entry (add to catalog.json "packages"):');
  // ignore: avoid_print
  print(const JsonEncoder.withIndent('  ').convert(entry));
}

Map<String, String> _parseArgs(List<String> args) {
  final map = <String, String>{};
  for (var i = 0; i < args.length - 1; i++) {
    if (args[i].startsWith('--')) {
      map[args[i].substring(2)] = args[i + 1];
      i++;
    }
  }
  return map;
}

Never _fail(String message) {
  stderr.writeln('Error: $message');
  exit(1);
}
