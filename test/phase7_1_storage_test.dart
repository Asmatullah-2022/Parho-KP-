import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parho_kp/data/content/connectivity.dart';
import 'package:parho_kp/data/content/content_package_download_service.dart';
import 'package:parho_kp/data/content/device_storage_probe.dart';
import 'package:parho_kp/data/content/package_catalog.dart';
import 'package:parho_kp/data/content/package_manifest.dart';
import 'package:parho_kp/data/database/app_database.dart';

/// A storage probe that returns a fixed free-byte value (or null = unknown).
class _FixedProbe implements StorageProbe {
  _FixedProbe(this.free);
  final int? free;
  @override
  Future<int?> freeBytes() async => free;
}

Future<({MockContentHost host, PackageMetadata meta})> _host() async {
  final host = MockContentHost();
  await host.prepare();
  final m = await host.fetchManifest();
  return (host: host, meta: m.packages.single);
}

ContentPackageDownloadService _service(
  AppDatabase db,
  MockContentHost host, {
  required StorageProbe probe,
}) {
  return ContentPackageDownloadService(
    db,
    httpClient: MockDownloadHttpClient(host),
    publicKeyProvider: FixedPublicKey(host.publicKeyBase64),
    connectivity: ManualConnectivity(ConnectivityStatus.wifi),
    storageProbe: probe,
    retryDelay: Duration.zero,
  );
}

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  group('required-space calculation', () {
    test('required = package size + temp overhead (+ margin)', () {
      final svc = ContentPackageDownloadService(
        db,
        httpClient: MockDownloadHttpClient(MockContentHost()),
        publicKeyProvider: const FixedPublicKey('x'),
        storageMarginBytes: 5 * 1024 * 1024,
      );
      const size = 10 * 1024 * 1024; // 10 MB
      // temp overhead = size + margin; required = size + overhead.
      expect(svc.tempDownloadOverheadBytes(size), size + 5 * 1024 * 1024);
      expect(svc.requiredFreeBytes(size), 2 * size + 5 * 1024 * 1024);
    });
  });

  group('DeviceStorageProbe (MB → bytes, safe fallback)', () {
    test('converts megabytes to bytes', () async {
      final probe = DeviceStorageProbe(reader: () async => 100.0); // 100 MB
      expect(await probe.freeBytes(), 100 * 1024 * 1024);
    });

    test('returns null (unknown) when detection is unavailable', () async {
      final err = DeviceStorageProbe(reader: () async => throw Exception('no'));
      expect(await err.freeBytes(), isNull);
      final none = DeviceStorageProbe(reader: () async => null);
      expect(await none.freeBytes(), isNull);
    });
  });

  group('download storage pre-check', () {
    test('enough storage → installs', () async {
      final r = await _host();
      final required = ContentPackageDownloadService(
        db,
        httpClient: MockDownloadHttpClient(r.host),
        publicKeyProvider: FixedPublicKey(r.host.publicKeyBase64),
      ).requiredFreeBytes(r.meta.sizeBytes);
      final svc = _service(db, r.host, probe: _FixedProbe(required + 1));
      final outcome = await svc.downloadAndInstall(
        r.meta,
        wifiOnly: false,
        allowMobileData: true,
      );
      expect(outcome.installed, isTrue);
    });

    test('insufficient storage → blocked, nothing installed', () async {
      final r = await _host();
      final svc = _service(db, r.host, probe: _FixedProbe(10)); // 10 bytes
      final outcome = await svc.downloadAndInstall(
        r.meta,
        wifiOnly: false,
        allowMobileData: true,
      );
      expect(outcome.error, DownloadError.insufficientStorage);
      expect(await db.allInstalledPackages(), isEmpty);
      expect(await db.subjectsForGrade(5), isEmpty);
    });

    test('unknown storage (null) → pre-check skipped, installs', () async {
      final r = await _host();
      final svc = _service(db, r.host, probe: _FixedProbe(null));
      final outcome = await svc.downloadAndInstall(
        r.meta,
        wifiOnly: false,
        allowMobileData: true,
      );
      expect(outcome.installed, isTrue);
    });

    test('insufficient storage never destroys an installed package', () async {
      final r = await _host();
      // Install v1 with plenty of space.
      final ok = await _service(db, r.host, probe: _FixedProbe(null))
          .downloadAndInstall(r.meta,
              wifiOnly: false, allowMobileData: true);
      expect(ok.installed, isTrue);
      final before = (await db.subjectsForGrade(5)).length;

      // A later download attempt with no space must not touch v1.
      final blocked = await _service(db, r.host, probe: _FixedProbe(1))
          .downloadAndInstall(r.meta,
              wifiOnly: false, allowMobileData: true);
      expect(blocked.error, DownloadError.insufficientStorage);
      expect((await db.subjectsForGrade(5)).length, before);
      expect((await db.allInstalledPackages()).single.version, '1');
    });
  });
}
