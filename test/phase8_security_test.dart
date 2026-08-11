import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parho_kp/data/content/download_http_client.dart';
import 'package:parho_kp/data/content/package_catalog.dart';
import 'package:parho_kp/data/content/package_zip_reader.dart';

List<int> _zipWith(Map<String, List<int>> entries) {
  final archive = Archive();
  entries.forEach((name, bytes) {
    archive.addFile(ArchiveFile(name, bytes.length, bytes));
  });
  return ZipEncoder().encode(archive)!;
}

List<int> _u(String s) => utf8.encode(s);

void main() {
  group('ZIP path-traversal (zip slip) rejection', () {
    test('rejects an archive entry that escapes with ..', () {
      final zip = _zipWith({
        'manifest.json': _u('{"packageId":"x","grade":5,"version":"1"}'),
        'content/subjects.json': _u('[]'),
        'content/units.json': _u('[]'),
        'content/lessons.json': _u('[]'),
        'content/questions.json': _u('[]'),
        'audio/../../../evil.mp3': _u('malicious'),
      });
      expect(
        () => const PackageZipReader().read(zip),
        throwsA(isA<PackageFormatException>()
            .having((e) => e.code, 'code', 'unsafe_path')),
      );
    });

    test('rejects an absolute archive entry path', () {
      final zip = _zipWith({
        'manifest.json': _u('{"packageId":"x","grade":5,"version":"1"}'),
        'content/subjects.json': _u('[]'),
        'content/units.json': _u('[]'),
        'content/lessons.json': _u('[]'),
        'content/questions.json': _u('[]'),
        '/etc/passwd': _u('x'),
      });
      expect(() => const PackageZipReader().read(zip),
          throwsA(isA<PackageFormatException>()));
    });
  });

  group('HTTPS-only enforcement (no unsafe HTTP endpoints)', () {
    test('download client refuses a non-HTTPS URL', () {
      expect(
        () => HttpDownloadClient().openStream('http://example.org/pkg.zip'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('remote catalog refuses a non-HTTPS URL', () {
      expect(
        () => RemotePackageManifestCatalog(
                catalogUrl: 'http://example.org/catalog.json')
            .fetchManifest(),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
