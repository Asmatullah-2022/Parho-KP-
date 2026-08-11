// Development helper: generate an Ed25519 signing key pair for content packages.
//
//   dart run tool/generate_keys.dart
//
// Prints a base64 PUBLIC key (ships in the app via CatalogConfig.publicKeyBase64)
// and a base64 PRIVATE key SEED.
//
// SECURITY — read carefully:
//   * The PRIVATE key must be stored ONLY in a secure secret manager or an
//     offline signing machine. NEVER commit it, NEVER put it in the APK,
//     source, config, logs, or this repository.
//   * Only the PUBLIC key goes into the app.
import 'dart:convert';

import 'package:cryptography/cryptography.dart';

Future<void> main() async {
  final algorithm = Ed25519();
  final keyPair = await algorithm.newKeyPair();
  final privateSeed = await keyPair.extractPrivateKeyBytes(); // 32-byte seed
  final publicKey = await keyPair.extractPublicKey();

  // ignore: avoid_print
  print('PUBLIC KEY  (base64, ships in the app):');
  // ignore: avoid_print
  print(base64Encode(publicKey.bytes));
  // ignore: avoid_print
  print('');
  // ignore: avoid_print
  print('PRIVATE KEY (base64 seed — STORE SECURELY, never commit):');
  // ignore: avoid_print
  print(base64Encode(privateSeed));
  // ignore: avoid_print
  print('');
  // ignore: avoid_print
  print('Set the public key in production, e.g.:');
  // ignore: avoid_print
  print('  --dart-define=PARHO_PUBLIC_KEY=<public-key-base64>');
}
