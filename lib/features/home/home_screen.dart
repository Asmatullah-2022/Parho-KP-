import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/view_models.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/utils/localized_text.dart';
import '../../shared/widgets/widgets.dart';

/// Main student dashboard: greeting, connectivity, a "Continue Learning" card
/// and a grid of quick actions.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final studentAsync = ref.watch(currentStudentProvider);
    final langCode = ref.watch(languageCodeProvider);

    return Scaffold(
      body: SafeArea(
        child: studentAsync.when(
          loading: () => const LoadingState(),
          error: (e, _) => ErrorState(
            onRetry: () => ref.invalidate(currentStudentProvider),
          ),
          data: (student) {
            final name = student?.name ?? '';
            final grade = student?.grade ?? 5;
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(continueTargetProvider);
                ref.invalidate(subjectProgressListProvider);
              },
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.greeting(name),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.gradeShort(grade),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      const OfflineBadge(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Offline lesson search entry.
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => context.push(Routes.search),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color:
                                Theme.of(context).colorScheme.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search_rounded,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 10),
                          Text(
                            l10n.searchHint,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _ContinueCard(langCode: langCode),
                  const SizedBox(height: 24),
                  Text(
                    l10n.whatToStudyToday,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 14),
                  _ActionsGrid(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ContinueCard extends ConsumerWidget {
  const _ContinueCard({required this.langCode});
  final String langCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final targetAsync = ref.watch(continueTargetProvider);

    return targetAsync.when(
      loading: () => const _ContinueSkeleton(),
      error: (_, _) => const SizedBox.shrink(),
      data: (ContinueTarget? target) {
        if (target == null) return const SizedBox.shrink();
        final subjectName = pickLang(langCode, target.subject.nameEn,
            target.subject.nameUr, target.subject.namePs);
        final lessonTitle = pickLang(langCode, target.lesson.titleEn,
            target.lesson.titleUr, target.lesson.titlePs);

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.blue, AppColors.blueDark],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.menu_book_rounded,
                      color: Colors.white, size: 26),
                  const SizedBox(width: 8),
                  Text(
                    l10n.continueLearning,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                subjectName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                lessonTitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: target.percent / 100,
                  minHeight: 10,
                  backgroundColor: Colors.white.withValues(alpha: 0.25),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.yellow),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.percent(target.percent),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.blueDark,
                  ),
                  onPressed: () =>
                      context.push(Routes.lessonPath(target.lesson.id)),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(l10n.continueLearningAction),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ContinueSkeleton extends StatelessWidget {
  const _ContinueSkeleton();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.blue.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}

class _ActionTile {
  const _ActionTile(this.emoji, this.label, this.color, this.onTap);
  final String emoji;
  final String label;
  final Color color;
  final VoidCallback onTap;
}

class _ActionsGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tiles = <_ActionTile>[
      _ActionTile('📚', l10n.tileMyLessons, AppColors.green,
          () => context.go(Routes.subjects)),
      _ActionTile('📝', l10n.tileQuiz, AppColors.blue,
          () => context.go(Routes.quiz)),
      _ActionTile('🤖', l10n.tileAiTutor, AppColors.blueDark,
          () => context.push(Routes.aiTutor)),
      _ActionTile('📥', l10n.tileOfflineLessons, AppColors.improving,
          () => context.push(Routes.offline)),
      _ActionTile('📊', l10n.tileMyProgress, AppColors.green,
          () => context.go(Routes.progress)),
      _ActionTile('⭐', l10n.favoritesTitle, AppColors.improving,
          () => context.push(Routes.favorites)),
      _ActionTile('🎧', l10n.tileAudioLearning, AppColors.blue,
          () => context.push(Routes.offline)),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 520 ? 3 : 2;
        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.15,
          children: tiles
              .map((t) => _ActionCard(tile: t))
              .toList(growable: false),
        );
      },
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.tile});
  final _ActionTile tile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: tile.onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: tile.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(tile.emoji, style: const TextStyle(fontSize: 30)),
              ),
              const SizedBox(height: 10),
              Text(
                tile.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
