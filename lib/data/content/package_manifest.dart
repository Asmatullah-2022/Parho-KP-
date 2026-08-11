import '../database/app_database.dart' show InstalledPackage;
import 'content_package_service.dart' show compareVersions;

/// Metadata describing one downloadable content package version, as published
/// in the catalog manifest. This is the untrusted wire model — every field is
/// parsed defensively and validated before use.
class PackageMetadata {
  const PackageMetadata({
    required this.packageId,
    required this.grade,
    required this.subject,
    required this.language,
    required this.version,
    required this.contentVersion,
    required this.sizeBytes,
    required this.downloadUrl,
    required this.sha256,
    required this.signature,
    this.releaseDate,
    this.minimumAppVersion = '1.0.0',
    this.title = '',
  });

  /// Stable id, e.g. "grade5_math_ur_v1".
  final String packageId;
  final int grade;

  /// Subject code, e.g. "math".
  final String subject;

  /// Content language code, e.g. "ur" (a package may still carry all languages).
  final String language;

  /// User-facing semantic version, e.g. "1" or "1.2.0".
  final String version;

  /// Monotonic content revision (integer) — used as a tie-breaker.
  final int contentVersion;
  final int sizeBytes;

  /// Where to fetch the package archive. `mock://…` for the dev host, otherwise
  /// an https URL.
  final String downloadUrl;

  /// Hex-encoded SHA-256 of the package archive bytes.
  final String sha256;

  /// Base64-encoded Ed25519 signature over the package archive bytes.
  final String signature;
  final DateTime? releaseDate;

  /// Minimum app version required to install this package.
  final String minimumAppVersion;

  /// Optional display title (falls back to a generated one in the UI).
  final String title;

  factory PackageMetadata.fromJson(Map<String, dynamic> json) {
    String req(String key) {
      final v = json[key];
      if (v is! String || v.isEmpty) {
        throw FormatException('Manifest field "$key" is missing.');
      }
      return v;
    }

    int reqInt(String key) {
      final v = json[key];
      if (v is num) return v.toInt();
      throw FormatException('Manifest field "$key" must be a number.');
    }

    DateTime? parseDate(Object? v) =>
        v is String ? DateTime.tryParse(v) : null;

    return PackageMetadata(
      packageId: req('packageId'),
      grade: reqInt('grade'),
      subject: req('subject'),
      language: req('language'),
      version: req('version'),
      contentVersion: reqInt('contentVersion'),
      sizeBytes: reqInt('sizeBytes'),
      downloadUrl: req('downloadUrl'),
      sha256: req('sha256'),
      signature: req('signature'),
      releaseDate: parseDate(json['releaseDate']),
      minimumAppVersion:
          (json['minimumAppVersion'] as String?) ?? '1.0.0',
      title: (json['title'] as String?) ?? '',
    );
  }

  Map<String, Object?> toJson() => {
        'packageId': packageId,
        'grade': grade,
        'subject': subject,
        'language': language,
        'version': version,
        'contentVersion': contentVersion,
        'sizeBytes': sizeBytes,
        'downloadUrl': downloadUrl,
        'sha256': sha256,
        'signature': signature,
        if (releaseDate != null)
          'releaseDate': releaseDate!.toIso8601String(),
        'minimumAppVersion': minimumAppVersion,
        if (title.isNotEmpty) 'title': title,
      };

  /// True if this app (at [appVersion]) is new enough to install the package.
  bool isSupportedBy(String appVersion) =>
      compareVersions(appVersion, minimumAppVersion) >= 0;
}

/// A parsed catalog manifest: the list of packages a catalog currently offers.
class ContentPackageManifest {
  const ContentPackageManifest({
    required this.manifestVersion,
    required this.packages,
    this.generatedAt,
  });

  final int manifestVersion;
  final List<PackageMetadata> packages;
  final DateTime? generatedAt;

  factory ContentPackageManifest.fromJson(Map<String, dynamic> json) {
    final rawPackages = json['packages'];
    if (rawPackages is! List) {
      throw const FormatException('Manifest has no "packages" list.');
    }
    return ContentPackageManifest(
      manifestVersion: (json['manifestVersion'] as num?)?.toInt() ?? 1,
      generatedAt: json['generatedAt'] is String
          ? DateTime.tryParse(json['generatedAt'] as String)
          : null,
      packages: rawPackages
          .map((e) => PackageMetadata.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, Object?> toJson() => {
        'manifestVersion': manifestVersion,
        if (generatedAt != null)
          'generatedAt': generatedAt!.toIso8601String(),
        'packages': packages.map((p) => p.toJson()).toList(),
      };
}

/// Status of a catalog package relative to what is installed on the device.
enum ManifestPackageStatus { installed, available, updateAvailable }

/// A catalog package paired with its computed install status.
class ManifestPackageEntry {
  const ManifestPackageEntry({
    required this.meta,
    required this.status,
    this.installedVersion,
  });

  final PackageMetadata meta;
  final ManifestPackageStatus status;
  final String? installedVersion;

  bool get isInstalled => status != ManifestPackageStatus.available;
  bool get canUpdate => status == ManifestPackageStatus.updateAvailable;
}

/// Computes Installed / Available / Update-available for every package in
/// [manifest] against the [installed] rows. Pure and offline.
List<ManifestPackageEntry> resolvePackageStatuses(
  ContentPackageManifest manifest,
  List<InstalledPackage> installed,
) {
  final byId = {for (final p in installed) p.packageId: p};
  final entries = <ManifestPackageEntry>[];
  for (final meta in manifest.packages) {
    final inst = byId[meta.packageId];
    if (inst == null) {
      entries.add(ManifestPackageEntry(
          meta: meta, status: ManifestPackageStatus.available));
    } else if (compareVersions(inst.version, meta.version) < 0) {
      entries.add(ManifestPackageEntry(
        meta: meta,
        status: ManifestPackageStatus.updateAvailable,
        installedVersion: inst.version,
      ));
    } else {
      entries.add(ManifestPackageEntry(
        meta: meta,
        status: ManifestPackageStatus.installed,
        installedVersion: inst.version,
      ));
    }
  }
  return entries;
}

/// The lifecycle phase of a package download/install. Drives the UI.
enum DownloadPhase {
  idle,
  waitingForWifi,
  downloading,
  paused,
  verifying,
  validating,
  installing,
  installed,
  failed,
  canceled,
}

/// Why a download/install failed — mapped to friendly, non-technical messages.
enum DownloadError {
  none,
  noInternet,
  timeout,
  httpError,
  wifiRequired,
  insufficientStorage,
  corruptPackage,
  invalidChecksum,
  invalidSignature,
  invalidManifest,
  unsupportedAppVersion,
  interrupted,
}

/// Observable state of a single package download/installation.
class PackageDownload {
  const PackageDownload({
    required this.packageId,
    this.phase = DownloadPhase.idle,
    this.bytesReceived = 0,
    this.totalBytes = 0,
    this.error = DownloadError.none,
  });

  final String packageId;
  final DownloadPhase phase;
  final int bytesReceived;
  final int totalBytes;
  final DownloadError error;

  /// Progress 0.0–1.0 (0 when total is unknown).
  double get progress =>
      totalBytes <= 0 ? 0 : (bytesReceived / totalBytes).clamp(0, 1);

  int get percent => (progress * 100).round();

  bool get isActive =>
      phase == DownloadPhase.downloading ||
      phase == DownloadPhase.verifying ||
      phase == DownloadPhase.validating ||
      phase == DownloadPhase.installing;

  PackageDownload copyWith({
    DownloadPhase? phase,
    int? bytesReceived,
    int? totalBytes,
    DownloadError? error,
  }) =>
      PackageDownload(
        packageId: packageId,
        phase: phase ?? this.phase,
        bytesReceived: bytesReceived ?? this.bytesReceived,
        totalBytes: totalBytes ?? this.totalBytes,
        error: error ?? this.error,
      );
}
