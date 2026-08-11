import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/app_settings.dart';
import '../../shared/widgets/widgets.dart';

/// Student profile hub with quick links to progress, offline content, settings
/// and the teacher dashboard.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final studentAsync = ref.watch(currentStudentProvider);
    final settings = ref.watch(settingsControllerProvider);

    String languageName() {
      switch (settings.language) {
        case AppLanguage.english:
          return l10n.languageEnglish;
        case AppLanguage.urdu:
          return l10n.languageUrdu;
        case AppLanguage.pashto:
          return l10n.languagePashto;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: SafeArea(
        child: studentAsync.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(
            onRetry: () => ref.invalidate(currentStudentProvider),
          ),
          data: (student) {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor:
                            AppColors.green.withValues(alpha: 0.15),
                        child: const Icon(Icons.person_rounded,
                            size: 56, color: AppColors.green),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        student?.name ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(
                            avatar: const Icon(Icons.school_rounded, size: 18),
                            label: Text(l10n.gradeShort(student?.grade ?? 5)),
                          ),
                          Chip(
                            avatar:
                                const Icon(Icons.translate_rounded, size: 18),
                            label: Text(languageName()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _ProfileTile(
                  icon: Icons.edit_rounded,
                  color: AppColors.blue,
                  label: l10n.editProfileTitle,
                  onTap: () => context.push(Routes.editProfile),
                ),
                _ProfileTile(
                  icon: Icons.star_rounded,
                  color: AppColors.yellowDark,
                  label: l10n.favoritesTitle,
                  onTap: () => context.push(Routes.favorites),
                ),
                _ProfileTile(
                  icon: Icons.bar_chart_rounded,
                  color: AppColors.green,
                  label: l10n.profileLearningProgress,
                  onTap: () => context.go(Routes.progress),
                ),
                _ProfileTile(
                  icon: Icons.emoji_events_rounded,
                  color: AppColors.yellowDark,
                  label: l10n.achievementsTitle,
                  onTap: () => context.push(Routes.achievements),
                ),
                _ProfileTile(
                  icon: Icons.assessment_rounded,
                  color: AppColors.blueDark,
                  label: l10n.reportTitle,
                  onTap: () => context.push(Routes.report),
                ),
                _ProfileTile(
                  icon: Icons.download_for_offline_rounded,
                  color: AppColors.blue,
                  label: l10n.profileOfflineContent,
                  onTap: () => context.push(Routes.offline),
                ),
                _ProfileTile(
                  icon: Icons.settings_rounded,
                  color: AppColors.blueDark,
                  label: l10n.profileSettings,
                  onTap: () => context.push(Routes.settings),
                ),
                _ProfileTile(
                  icon: Icons.groups_rounded,
                  color: AppColors.improving,
                  label: l10n.profileTeacherDashboard,
                  onTap: () => context.push(Routes.teacher),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.14),
          child: Icon(icon, color: color),
        ),
        title: Text(label,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
