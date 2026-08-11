import '../database/app_database.dart';
import 'content_importer.dart';
import 'content_models.dart';

/// Install state of a content package relative to what is on the device.
enum PackageStatus {
  /// Installed and up to date.
  installed,

  /// Not installed yet — available to download.
  available,

  /// Installed, but a newer version is available.
  updateAvailable,
}

/// Compares two dotted semantic-version strings (e.g. "1.2.0" vs "1.10.0").
/// Missing/garbage segments count as 0. Returns <0, 0, or >0.
int compareVersions(String a, String b) {
  List<int> parts(String v) => v
      .split('.')
      .map((s) => int.tryParse(s.trim()) ?? 0)
      .toList(growable: true);
  final pa = parts(a);
  final pb = parts(b);
  final len = pa.length > pb.length ? pa.length : pb.length;
  for (var i = 0; i < len; i++) {
    final x = i < pa.length ? pa[i] : 0;
    final y = i < pb.length ? pb[i] : 0;
    if (x != y) return x < y ? -1 : 1;
  }
  return 0;
}

/// Metadata describing an offline content package (installed or available).
class PackageMeta {
  const PackageMeta({
    required this.packageId,
    required this.grade,
    required this.title,
    required this.version,
    this.province = 'Khyber Pakhtunkhwa',
    this.isDemo = true,
    this.sizeBytes = 0,
  });

  final String packageId;
  final int grade;
  final String title;
  final String version;
  final String province;
  final bool isDemo;
  final int sizeBytes;
}

/// A package the catalog can offer, bundled with the actual content to install.
class AvailablePackage {
  const AvailablePackage({required this.meta, required this.package});
  final PackageMeta meta;
  final ContentPackage package;
}

/// A package entry with its computed [status] (for the download/update UI).
class PackageStatusEntry {
  const PackageStatusEntry({
    required this.meta,
    required this.status,
    this.installedVersion,
  });

  final PackageMeta meta;
  final PackageStatus status;
  final String? installedVersion;

  bool get canUpdate => status == PackageStatus.updateAvailable;
  bool get isInstalled => status != PackageStatus.available;
}

/// Where the list of *available* packages comes from. Offline-first: the
/// default implementation is a bundled catalog, but a future implementation
/// could fetch a signed manifest from a secure server without changing callers.
abstract class PackageCatalog {
  Future<List<AvailablePackage>> availablePackages();
}

/// An empty catalog (default when no bundled/remote catalog is wired). The app
/// still works fully — content is already seeded into the database.
class EmptyPackageCatalog implements PackageCatalog {
  const EmptyPackageCatalog();
  @override
  Future<List<AvailablePackage>> availablePackages() async => const [];
}

/// A fixed in-memory catalog, useful for bundled packages and tests.
class InMemoryPackageCatalog implements PackageCatalog {
  const InMemoryPackageCatalog(this.packages);
  final List<AvailablePackage> packages;
  @override
  Future<List<AvailablePackage>> availablePackages() async => packages;
}

/// Manages offline-first, versioned content packages: what is installed, what
/// is available, and what has an update. Installs go through [ContentImporter]
/// so every package is validated before it touches the database.
class ContentPackageService {
  ContentPackageService(
    this.db, {
    this.catalog = const EmptyPackageCatalog(),
  }) : _importer = ContentImporter(db);

  final AppDatabase db;
  final PackageCatalog catalog;
  final ContentImporter _importer;

  /// Size (bytes) above which the UI should ask before downloading on the
  /// student's connection. Content is text-only so packages are small; audio
  /// packs can be larger.
  static const int largeDownloadThresholdBytes = 5 * 1024 * 1024;

  /// Records demo metadata for content already seeded into the DB, so the
  /// packages screen can show an "Installed" row for the built-in curriculum.
  Future<void> registerInstalled(PackageMeta meta) {
    return db.upsertInstalledPackage(
      packageId: meta.packageId,
      grade: meta.grade,
      title: meta.title,
      version: meta.version,
      province: meta.province,
      isDemo: meta.isDemo,
      sizeBytes: meta.sizeBytes,
    );
  }

  Future<List<InstalledPackage>> installedPackages() =>
      db.allInstalledPackages();

  /// Computes the status of every catalog package against what is installed,
  /// plus any installed package that is no longer in the catalog.
  Future<List<PackageStatusEntry>> statusEntries() async {
    final installed = {
      for (final p in await db.allInstalledPackages()) p.packageId: p,
    };
    final available = await catalog.availablePackages();
    final entries = <PackageStatusEntry>[];
    final seen = <String>{};

    for (final a in available) {
      seen.add(a.meta.packageId);
      final inst = installed[a.meta.packageId];
      if (inst == null) {
        entries.add(
          PackageStatusEntry(meta: a.meta, status: PackageStatus.available),
        );
      } else if (compareVersions(inst.version, a.meta.version) < 0) {
        entries.add(PackageStatusEntry(
          meta: a.meta,
          status: PackageStatus.updateAvailable,
          installedVersion: inst.version,
        ));
      } else {
        entries.add(PackageStatusEntry(
          meta: a.meta,
          status: PackageStatus.installed,
          installedVersion: inst.version,
        ));
      }
    }

    // Installed packages not present in the catalog (e.g. bundled demo).
    for (final inst in installed.values) {
      if (seen.contains(inst.packageId)) continue;
      entries.add(PackageStatusEntry(
        meta: PackageMeta(
          packageId: inst.packageId,
          grade: inst.grade,
          title: inst.title,
          version: inst.version,
          province: inst.province,
          isDemo: inst.isDemo,
          sizeBytes: inst.sizeBytes,
        ),
        status: PackageStatus.installed,
        installedVersion: inst.version,
      ));
    }

    entries.sort((a, b) => a.meta.grade.compareTo(b.meta.grade));
    return entries;
  }

  /// Whether a download of [sizeBytes] should prompt the user first, given the
  /// connection. On mobile data we always ask; on Wi-Fi we only ask for large
  /// packages. Callers pass the resolved connection state (no network sniffing
  /// happens in this pure decision helper).
  bool shouldConfirmDownload({
    required int sizeBytes,
    required bool onWifi,
  }) {
    if (!onWifi) return true; // always confirm on mobile data
    return sizeBytes >= largeDownloadThresholdBytes;
  }

  /// Whether a download is allowed at all under the Wi-Fi-only preference.
  bool canDownloadNow({required bool onWifi, required bool wifiOnly}) {
    return onWifi || !wifiOnly;
  }

  /// Installs (or updates) a package: validates, replaces that grade's content,
  /// and records the new version metadata. Fully offline and transactional —
  /// an invalid package is rejected without changing anything.
  Future<void> install(AvailablePackage available) async {
    await _importer.importPackage(available.package, replaceGrade: true);
    await registerInstalled(available.meta);
  }

  /// Convenience: find and install a catalog package by id. Returns false if
  /// the id is not in the catalog.
  Future<bool> installById(String packageId) async {
    final available = await catalog.availablePackages();
    for (final a in available) {
      if (a.meta.packageId == packageId) {
        await install(a);
        return true;
      }
    }
    return false;
  }
}
