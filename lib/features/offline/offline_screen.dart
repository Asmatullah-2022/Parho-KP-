import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/view_models.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/app_settings.dart';
import '../../shared/utils/localized_text.dart';
import '../../shared/widgets/widgets.dart';

/// Offline Lessons: download subjects for the student's grade so they work
/// without internet. Shows total storage used and a Wi-Fi-only toggle.
class OfflineScreen extends ConsumerWidget {
  const OfflineScreen({super.key});

  String _formatSize(int bytes) {
    if (bytes <= 0) return '0 KB';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(0)} KB';
    return '${(kb / 1024).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final code = ref.watch(languageCodeProvider);
    final settings = ref.watch(settingsControllerProvider);
    final statesAsync = ref.watch(downloadStatesProvider);
    final studentAsync = ref.watch(currentStudentProvider);

    Future<void> toggle(DownloadState d, bool value) async {
      final student = studentAsync.value;
      if (student == null) return;
      await ref
          .read(learningRepositoryProvider)
          .setDownloaded(student.grade, d.subject.id, value);
      ref.invalidate(downloadStatesProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(
                value ? l10n.downloadStarted : l10n.downloadDeleted),
          ));
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.offlineLessonsTitle)),
      body: SafeArea(
        child: statesAsync.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(
            onRetry: () => ref.invalidate(downloadStatesProvider),
          ),
          data: (states) {
            final totalBytes = states
                .where((s) => s.isDownloaded)
                .fold<int>(0, (a, b) => a + b.sizeBytes);
            final gradeLabel =
                l10n.gradeShort(studentAsync.value?.grade ?? 5);

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _InfoBanner(text: l10n.offlineWorksWithout),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.sd_storage_rounded,
                            color: AppColors.blue),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(l10n.storageUsed,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                        ),
                        Text(_formatSize(totalBytes),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  value: settings.downloadOnWifiOnly,
                  onChanged: (v) => ref
                      .read(settingsControllerProvider.notifier)
                      .setDownloadOnWifiOnly(v),
                  secondary: const Icon(Icons.wifi_rounded),
                  title: Text(l10n.downloadOnWifi),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(gradeLabel,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                ),
                const SizedBox(height: 8),
                for (final d in states)
                  Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Text(d.subject.emoji,
                              style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pickLang(code, d.subject.nameEn,
                                      d.subject.nameUr, d.subject.namePs),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  d.isDownloaded
                                      ? '${l10n.offlinePackageSize}: ${_formatSize(d.sizeBytes)}'
                                      : l10n.offlineAvailable,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          DownloadButton(
                            isDownloaded: d.isDownloaded,
                            onDownload: () => toggle(d, true),
                            onDelete: () => toggle(d, false),
                            onUpdate: () => toggle(d, true),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_rounded, color: AppColors.green),
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
