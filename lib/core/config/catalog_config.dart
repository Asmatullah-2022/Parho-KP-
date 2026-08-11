/// Single configuration point for the content-package catalog (Phase 6).
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
class CatalogConfig {
  const CatalogConfig({
    this.catalogUrl = '',
    this.publicKeyBase64 = '',
    this.appVersion = '1.0.0',
    this.useMockHost = true,
  });

  /// HTTPS endpoint that returns the catalog manifest JSON. Empty in this build
  /// (no production server yet) — see [useMockHost].
  final String catalogUrl;

  /// Base64-encoded Ed25519 public key used to verify package signatures.
  /// Empty here; a production build injects the real public key. When the mock
  /// host is used, its per-run development key is used instead (dev only).
  final String publicKeyBase64;

  /// The current app version, compared against a package's `minimumAppVersion`.
  final String appVersion;

  /// When true, the app uses the in-repo development mock host instead of a
  /// remote server. This is clearly a development aid — NOT a production
  /// server. Set to false and provide [catalogUrl] + [publicKeyBase64] to use a
  /// real signed catalog.
  final bool useMockHost;

  bool get hasRemoteCatalog => catalogUrl.isNotEmpty;

  CatalogConfig copyWith({
    String? catalogUrl,
    String? publicKeyBase64,
    String? appVersion,
    bool? useMockHost,
  }) =>
      CatalogConfig(
        catalogUrl: catalogUrl ?? this.catalogUrl,
        publicKeyBase64: publicKeyBase64 ?? this.publicKeyBase64,
        appVersion: appVersion ?? this.appVersion,
        useMockHost: useMockHost ?? this.useMockHost,
      );

  /// The default configuration shipped in this build: development mock host,
  /// no production server. Replace for production.
  static const CatalogConfig dev = CatalogConfig();
}
