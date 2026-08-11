import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/content/content_delivery_providers.dart';
import '../../data/content/package_manifest.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/app_settings.dart';
import '../../shared/widgets/widgets.dart';

/// Content Packages: browse installable/updatable curriculum packages with
/// Installed / Available / Update-available status, download progress, and
/// verified installation. Works offline (installed content always shows).
class ContentPackagesScreen extends ConsumerStatefulWidget {
  const ContentPackagesScreen({super.key});

  @override
  ConsumerState<ContentPackagesScreen> createState() =>
      _ContentPackagesScreenState();
}

class _ContentPackagesScreenState
    extends ConsumerState<ContentPackagesScreen> {
  /// Live download state per package id (drives the progress bars).
  final Map<String, PackageDownload> _downloads = {};

  String _formatSize(int bytes) {
    if (bytes <= 0) return '0 KB';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(0)} KB';
    return '${(kb / 1024).toStringAsFixed(1)} MB';
  }

  String _errorMessage(AppLocalizations l10n, DownloadError e) => switch (e) {
        DownloadError.noInternet => l10n.pkgErrNoInternet,
        DownloadError.timeout => l10n.pkgErrTimeout,
        DownloadError.httpError => l10n.pkgErrHttp,
        DownloadError.insufficientStorage => l10n.pkgErrStorage,
        DownloadError.corruptPackage => l10n.pkgErrCorrupt,
        DownloadError.invalidChecksum => l10n.pkgErrChecksum,
        DownloadError.invalidSignature => l10n.pkgErrSignature,
        DownloadError.invalidManifest => l10n.pkgErrCorrupt,
        DownloadError.unsupportedAppVersion => l10n.pkgErrUnsupportedApp,
        DownloadError.wifiRequired => l10n.pkgErrWifiRequired,
        DownloadError.interrupted => l10n.pkgErrTimeout,
        DownloadError.none => '',
      };

  Future<void> _install(
    AppLocalizations l10n,
    PackageMetadata meta,
  ) async {
    final settings = ref.read(settingsControllerProvider);
    final service = ref.read(contentPackageDownloadServiceProvider);

    // For a large package, confirm before starting (never silently pull data).
    if (meta.sizeBytes >= 5 * 1024 * 1024) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.packageConfirmTitle),
          content: Text(l10n.packageConfirmBody(_formatSize(meta.sizeBytes))),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.actionCancel)),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l10n.labelDownload)),
          ],
        ),
      );
      if (proceed != true) return;
    }

    setState(() => _downloads[meta.packageId] =
        PackageDownload(packageId: meta.packageId));

    final outcome = await service.downloadAndInstall(
      meta,
      wifiOnly: settings.downloadOnWifiOnly,
      allowMobileData: settings.allowMobileDataDownloads,
      onProgress: (s) {
        if (mounted) setState(() => _downloads[meta.packageId] = s);
      },
    );

    if (!mounted) return;
    setState(() => _downloads.remove(meta.packageId));

    if (outcome.installed) {
      ref.read(refreshTickProvider.notifier).state++;
      ref.invalidate(packageStatusesProvider);
      ref.invalidate(installedPackagesProvider);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.packageInstalledOk)));
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            SnackBar(content: Text(_errorMessage(l10n, outcome.error))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final statusesAsync = ref.watch(packageStatusesProvider);
    final installedAsync = ref.watch(installedPackagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.contentPackagesTitle),
        actions: [
          IconButton(
            tooltip: l10n.packageCheckUpdates,
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.invalidate(packageStatusesProvider);
              ref.invalidate(installedPackagesProvider);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: statusesAsync.when(
          loading: () => const LoadingState(),
          error: (_, _) =>
              ErrorState(onRetry: () => ref.invalidate(packageStatusesProvider)),
          data: (result) {
            final installed = installedAsync.value ?? const [];
            // Package ids present in the catalog (to avoid duplicate rows).
            final catalogIds =
                result.entries.map((e) => e.meta.packageId).toSet();
            final installedOnly = installed
                .where((p) => !catalogIds.contains(p.packageId))
                .toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (result.offline)
                  _Banner(
                    icon: Icons.cloud_off_rounded,
                    color: AppColors.blue,
                    text: l10n.packageOfflineNotice,
                  ),
                if (result.offline) const SizedBox(height: 12),
                for (final entry in result.entries)
                  _PackageCard(
                    title: entry.meta.title.isNotEmpty
                        ? entry.meta.title
                        : 'Grade ${entry.meta.grade}',
                    version: entry.meta.version,
                    size: _formatSize(entry.meta.sizeBytes),
                    status: entry.status,
                    download: _downloads[entry.meta.packageId],
                    onAction: entry.status == ManifestPackageStatus.installed
                        ? null
                        : () => _install(l10n, entry.meta),
                    l10n: l10n,
                  ),
                // Installed packages not in the catalog (e.g. built-in demo).
                for (final p in installedOnly)
                  _PackageCard(
                    title: p.title,
                    version: p.version,
                    size: _formatSize(p.sizeBytes),
                    status: ManifestPackageStatus.installed,
                    download: null,
                    onAction: null,
                    l10n: l10n,
                  ),
                if (result.entries.isEmpty && installedOnly.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: EmptyState(
                        icon: '📦', body: l10n.packageNoneAvailable),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({
    required this.title,
    required this.version,
    required this.size,
    required this.status,
    required this.download,
    required this.onAction,
    required this.l10n,
  });

  final String title;
  final String version;
  final String size;
  final ManifestPackageStatus status;
  final PackageDownload? download;
  final VoidCallback? onAction;
  final AppLocalizations l10n;

  String get _statusLabel => switch (status) {
        ManifestPackageStatus.installed => l10n.packageStatusInstalled,
        ManifestPackageStatus.available => l10n.packageStatusAvailable,
        ManifestPackageStatus.updateAvailable => l10n.packageStatusUpdate,
      };

  Color get _statusColor => switch (status) {
        ManifestPackageStatus.installed => AppColors.green,
        ManifestPackageStatus.available => AppColors.blue,
        ManifestPackageStatus.updateAvailable => AppColors.yellowDark,
      };

  String _phaseLabel() {
    final d = download;
    if (d == null) return '';
    return switch (d.phase) {
      DownloadPhase.verifying => l10n.packageVerifying,
      DownloadPhase.validating => l10n.packageVerifying,
      DownloadPhase.installing => l10n.packageInstalling,
      _ => l10n.packageDownloading,
    };
  }

  @override
  Widget build(BuildContext context) {
    final d = download;
    final busy = d != null && d.phase != DownloadPhase.failed;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text('v$version • $size',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                _StatusChip(label: _statusLabel, color: _statusColor),
              ],
            ),
            if (busy) ...[
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: d.phase == DownloadPhase.downloading && d.totalBytes > 0
                    ? d.progress
                    : null,
              ),
              const SizedBox(height: 6),
              Text('${_phaseLabel()}  ${d.phase == DownloadPhase.downloading ? '${d.percent}%' : ''}',
                  style: Theme.of(context).textTheme.bodySmall),
            ] else if (onAction != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: FilledButton.icon(
                  onPressed: onAction,
                  icon: Icon(
                    status == ManifestPackageStatus.updateAvailable
                        ? Icons.refresh_rounded
                        : Icons.download_rounded,
                    size: 20,
                  ),
                  label: Text(status == ManifestPackageStatus.updateAvailable
                      ? l10n.offlineUpdate
                      : l10n.labelDownload),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.icon, required this.color, required this.text});
  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
