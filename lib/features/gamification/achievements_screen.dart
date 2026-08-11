import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import 'gamification_service.dart';

/// Shows the student's achievements and points. Encouraging and finite — no
/// gambling or addictive mechanics.
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  String _title(AppLocalizations l10n, String code) => switch (code) {
        'first_lesson' => l10n.achievementFirstLesson,
        'first_quiz' => l10n.achievementFirstQuiz,
        'perfect_score' => l10n.achievementPerfectScore,
        'five_lessons' => l10n.achievementFiveLessons,
        'ten_lessons' => l10n.achievementTenLessons,
        'seven_day_streak' => l10n.achievementSevenDayStreak,
        _ => code,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(achievementsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.achievementsTitle)),
      body: SafeArea(
        child: async.when(
          loading: () => const LoadingState(),
          error: (_, _) =>
              ErrorState(onRetry: () => ref.invalidate(achievementsProvider)),
          data: (state) {
            final unlockedCodes = {for (final a in state.unlocked) a.code};
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  color: AppColors.yellow.withValues(alpha: 0.18),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Icon(Icons.emoji_events_rounded,
                            color: AppColors.yellowDark, size: 40),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${state.points}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.w900)),
                              Text(l10n.achievementsPointsLabel,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                        ),
                        Text(
                          '${state.unlocked.length}/${AchievementCatalog.all.length}',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (state.unlocked.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 12),
                    child: Text(l10n.achievementsEmpty,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                for (final def in AchievementCatalog.all)
                  _AchievementTile(
                    emoji: def.emoji,
                    title: _title(l10n, def.code),
                    points: def.points,
                    unlocked: unlockedCodes.contains(def.code),
                    unlockedLabel: l10n.achievementsUnlockedLabel,
                    lockedLabel: l10n.achievementsLockedLabel,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({
    required this.emoji,
    required this.title,
    required this.points,
    required this.unlocked,
    required this.unlockedLabel,
    required this.lockedLabel,
  });

  final String emoji;
  final String title;
  final int points;
  final bool unlocked;
  final String unlockedLabel;
  final String lockedLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Opacity(
        opacity: unlocked ? 1 : 0.5,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Text(emoji, style: const TextStyle(fontSize: 32)),
          title: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          subtitle: Text('$points ${'★'}'),
          trailing: Icon(
            unlocked ? Icons.check_circle_rounded : Icons.lock_rounded,
            color: unlocked ? AppColors.green : Colors.grey,
            semanticLabel: unlocked ? unlockedLabel : lockedLabel,
          ),
        ),
      ),
    );
  }
}
