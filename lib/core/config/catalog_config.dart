/// Tunables for the download subsystem. Kept in config so behaviour can be
/// adjusted per build without touching the download code.
class DownloadConfig {
  const DownloadConfig({
    this.wifiOnlyByDefault = true,
    this.allowMobileDataByDefault = false,
    this.largeDownloadThresholdBytes = 5 * 1024 * 1024,
    this.maxRetries = 3,
    this.chunkBytes = 32 * 1024,
  });

  final bool wifiOnlyByDefault;
  final bool allowMobileDataByDefault;
  final int largeDownloadThresholdBytes;
  final int maxRetries;
  final int chunkBytes;
}

/// Non-secret feature flags. Never put secrets here.
class FeatureFlags {
  const FeatureFlags({
    this.offlineAudio = true,
    this.autoCheckUpdates = true,
    this.contentPackages = true,
  });

  final bool offlineAudio;
  final bool autoCheckUpdates;
  final bool contentPackages;
}

/// Single configuration point for the content-package catalog.
///
/// The production catalog endpoint and the **public** verification key are set
/// here (or injected at build time) — nowhere else in the app. This keeps the
/// server URL from being hardcoded throughout the codebase and makes it trivial
/// to switch between the development mock host and a real production server.
///
/// SECURITY:
///  * Only the **public** Ed25519 verification key ever lives in the app.
///  * The matching **private** signing key MUST live only on your build/release
///    infrastructure — never in this repository or the shipped APK.
///  * No secrets (private keys, tokens, passwords) belong in this file.
class CatalogConfig {
  const CatalogConfig({
    this.catalogUrl = '',
    this.publicKeyBase64 = '',
    this.appVersion = '1.0.0',
    this.useMockHost = true,
    this.download = const DownloadConfig(),
    this.features = const FeatureFlags(),
  });

  /// HTTPS endpoint that returns the catalog manifest JSON (e.g. a static file
  /// on a CDN). Configurable per build; never hardcoded elsewhere.
  final String catalogUrl;

  /// Base64-encoded Ed25519 public key used to verify package signatures.
  /// Empty in the dev/mock build; a production build injects the real public
  /// key. When the mock host is used, its per-run development key is used.
  final String publicKeyBase64;

  /// The current app version, compared against a package's `minimumAppVersion`.
  final String appVersion;

  /// When true, the app uses the in-repo development mock host instead of a
  /// remote server. This is a development aid — NOT a production server. Set to
  /// false and provide [catalogUrl] + [publicKeyBase64] for a real catalog.
  final bool useMockHost;

  final DownloadConfig download;
  final FeatureFlags features;

  bool get hasRemoteCatalog => catalogUrl.isNotEmpty;

  CatalogConfig copyWith({
    String? catalogUrl,
    String? publicKeyBase64,
    String? appVersion,
    bool? useMockHost,
    DownloadConfig? download,
    FeatureFlags? features,
  }) =>
      CatalogConfig(
        catalogUrl: catalogUrl ?? this.catalogUrl,
        publicKeyBase64: publicKeyBase64 ?? this.publicKeyBase64,
        appVersion: appVersion ?? this.appVersion,
        useMockHost: useMockHost ?? this.useMockHost,
        download: download ?? this.download,
        features: features ?? this.features,
      );

  /// DEVELOPMENT configuration: in-app mock host, per-run dev key, no server.
  /// This is the default shipped in this build.
  static const CatalogConfig dev = CatalogConfig();

  /// PRODUCTION configuration template. Fill in [catalogUrl] and
  /// [publicKeyBase64] with your real values (the public key only) at build
  /// time — e.g. via `--dart-define` and a small loader, or by editing this
  /// constant in your release branch. `useMockHost` is false so the app talks
  /// to the real catalog.
  ///
  /// The private signing key is NEVER referenced here or anywhere in the app.
  static const CatalogConfig production = CatalogConfig(
    useMockHost: false,
    // TODO(release): set to your CDN catalog URL, e.g.
    //   'https://cdn.example.org/parho-kp/catalog.json'
    catalogUrl: String.fromEnvironment('PARHO_CATALOG_URL'),
    // TODO(release): set to your base64 Ed25519 PUBLIC key (public only!).
    publicKeyBase64: String.fromEnvironment('PARHO_PUBLIC_KEY'),
    appVersion: '1.0.0',
  );
}
