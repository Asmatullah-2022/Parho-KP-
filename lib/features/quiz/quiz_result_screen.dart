import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';

/// Celebratory quiz result: score, percentage, correct/wrong counts, and the
/// next actions (Practice Again / Next Lesson).
class QuizResultScreen extends ConsumerWidget {
  const QuizResultScreen({super.key, required this.attemptId});
  final int attemptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final attemptAsync = ref.watch(quizAttemptProvider(attemptId));

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: attemptAsync.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(
            onRetry: () => ref.invalidate(quizAttemptProvider(attemptId)),
          ),
          data: (attempt) {
            if (attempt == null) {
              return EmptyState(icon: '📝', body: l10n.emptyBody);
            }
            final percent = attempt.total == 0
                ? 0
                : ((attempt.score / attempt.total) * 100).round();
            final wrong = attempt.total - attempt.score;
            final passed = percent >= 60;

            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Text(passed ? '🎉' : '💪',
                      style: const TextStyle(fontSize: 72)),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    l10n.quizComplete,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.green.withValues(alpha: 0.10),
                      border:
                          Border.all(color: AppColors.green, width: 4),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.scoreOutOf(attempt.score, attempt.total),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          l10n.percent(percent),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: AppColors.green),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        icon: Icons.check_circle_rounded,
                        color: AppColors.green,
                        label: l10n.labelCorrect,
                        value: attempt.score.toString(),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _StatBox(
                        icon: Icons.cancel_rounded,
                        color: AppColors.needsPractice,
                        label: l10n.labelWrong,
                        value: wrong.toString(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: l10n.practiceAgain,
                  icon: Icons.refresh_rounded,
                  onPressed: () => context
                      .pushReplacement(Routes.quizPath(attempt.lessonId)),
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                  label: l10n.nextLesson,
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => context.go(Routes.home),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
