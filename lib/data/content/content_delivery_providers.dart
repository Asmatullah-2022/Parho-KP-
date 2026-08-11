import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/catalog_config.dart';
import '../../shared/providers/app_settings.dart';
import '../../shared/services/file_audio_player.dart';
import '../../shared/services/lesson_audio_service.dart';
import '../../shared/services/tts_service.dart';
import '../database/app_database.dart';
import '../providers.dart';
import 'audio_store.dart';
import 'connectivity.dart';
import 'connectivity_plus_service.dart';
import 'content_package_download_service.dart';
import 'download_http_client.dart';
import 'package_catalog.dart';
import 'package_manifest.dart';
import 'production_stores.dart';

/// Single configuration point for the catalog (endpoint + public key + app
/// version). Override in `main()` for production.
final catalogConfigProvider =
    Provider<CatalogConfig>((ref) => CatalogConfig.dev);

/// The development mock content host (builds + signs the demo package). Only
/// created when [CatalogConfig.useMockHost] is true.
final mockContentHostProvider = Provider<MockContentHost?>((ref) {
  final config = ref.watch(catalogConfigProvider);
  return config.useMockHost ? MockContentHost() : null;
});

/// The catalog source (mock host in development, remote server in production).
final packageManifestCatalogProvider =
    Provider<PackageManifestCatalog>((ref) {
  final config = ref.watch(catalogConfigProvider);
  final host = ref.watch(mockContentHostProvider);
  if (config.useMockHost && host != null) {
    return MockPackageManifestCatalog(host);
  }
  return RemotePackageManifestCatalog(catalogUrl: config.catalogUrl);
});

/// The audio store for downloaded offline lesson audio (file-based on device).
final audioStoreProvider = Provider<AudioStore>((ref) => FileAudioStore());

/// Plays lesson audio: a downloaded offline audio file when present, otherwise
/// on-device TTS (see [LessonAudioService]). Fully offline once installed.
final lessonAudioServiceProvider = Provider<LessonAudioService>((ref) {
  return LessonAudioService(
    tts: ref.watch(ttsServiceProvider),
    filePlayer: FileAudioPlayer(),
  );
});

/// Resolves a lesson's stored `audioAsset` to a playable absolute path (or null
/// when the file isn't installed). Offline lookup on the device.
final resolvedLessonAudioProvider =
    FutureProvider.family<String?, String?>((ref, audioAsset) async {
  if (audioAsset == null || audioAsset.isEmpty) return null;
  return ref.watch(audioStoreProvider).resolve(audioAsset);
});

/// The connectivity source. If the user forced Offline Mode we honour it;
/// otherwise real detection via `connectivity_plus` (which fails safe to Wi-Fi
/// when the platform channel is unavailable, e.g. in tests).
final connectivityProvider = Provider<Connectivity>((ref) {
  final offline =
      ref.watch(settingsControllerProvider.select((s) => s.offlineMode));
  if (offline) return ManualConnectivity(ConnectivityStatus.offline);
  return ConnectivityPlusService();
});

/// The download + install service, wired for the current (dev or prod) source.
final contentPackageDownloadServiceProvider =
    Provider<ContentPackageDownloadService>((ref) {
  final db = ref.watch(databaseProvider);
  final config = ref.watch(catalogConfigProvider);
  final host = ref.watch(mockContentHostProvider);

  final DownloadHttpClient httpClient;
  final PublicKeyProvider keyProvider;
  if (config.useMockHost && host != null) {
    httpClient = MockDownloadHttpClient(host);
    keyProvider = _MockHostKeyProvider(host);
  } else {
    httpClient = HttpDownloadClient();
    keyProvider = FixedPublicKey(config.publicKeyBase64);
  }

  return ContentPackageDownloadService(
    db,
    httpClient: httpClient,
    publicKeyProvider: keyProvider,
    connectivity: ref.watch(connectivityProvider),
    audioStore: ref.watch(audioStoreProvider),
    partialStore: FilePartialDownloadStore(),
    appVersion: config.appVersion,
    maxRetries: config.download.maxRetries,
  );
});

/// Reads the mock host's per-run public key (dev only).
class _MockHostKeyProvider implements PublicKeyProvider {
  _MockHostKeyProvider(this.host);
  final MockContentHost host;
  @override
  Future<String> publicKeyBase64() async {
    await host.prepare();
    return host.publicKeyBase64;
  }
}

/// Installed packages on the device (always available, even offline).
final installedPackagesProvider =
    FutureProvider<List<InstalledPackage>>((ref) async {
  ref.watch(refreshTickProvider);
  return ref.watch(databaseProvider).allInstalledPackages();
});

/// The resolved package list: catalog packages with Installed / Available /
/// Update-available status. If the catalog is unreachable, this reports an
/// offline state — installed content still works.
final packageStatusesProvider =
    FutureProvider<PackageCatalogResult>((ref) async {
  ref.watch(refreshTickProvider);
  final installed = await ref.watch(databaseProvider).allInstalledPackages();
  final connectivity = await ref.watch(connectivityProvider).status();
  if (connectivity == ConnectivityStatus.offline) {
    return PackageCatalogResult(entries: const [], offline: true);
  }
  try {
    final manifest =
        await ref.watch(packageManifestCatalogProvider).fetchManifest();
    return PackageCatalogResult(
      entries: resolvePackageStatuses(manifest, installed),
      offline: false,
    );
  } catch (_) {
    // Catalog unreachable — not an error for the student; installed content is
    // still fully usable.
    return PackageCatalogResult(entries: const [], offline: true);
  }
});

/// The outcome of resolving the catalog against installed packages.
class PackageCatalogResult {
  const PackageCatalogResult({required this.entries, required this.offline});
  final List<ManifestPackageEntry> entries;
  final bool offline;
}
