import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../data/models/view_models.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/utils/localized_text.dart';
import '../../shared/widgets/widgets.dart';

/// Shows a subject's overall progress and its units expanded into lessons.
class SubjectDetailScreen extends ConsumerWidget {
  const SubjectDetailScreen({super.key, required this.subjectId});
  final int subjectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final langCode = ref.watch(languageCodeProvider);
    final detailAsync = ref.watch(subjectDetailProvider(subjectId));

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: detailAsync.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(
            onRetry: () => ref.invalidate(subjectDetailProvider(subjectId)),
          ),
          data: (SubjectDetail? detail) {
            if (detail == null) {
              return EmptyState(icon: '📚', body: l10n.emptyBody);
            }
            final subjectName = pickLang(langCode, detail.subject.nameEn,
                detail.subject.nameUr, detail.subject.namePs);
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    Text(detail.subject.emoji,
                        style: const TextStyle(fontSize: 40)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        subjectName,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(l10n.overallProgress,
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                LabeledProgressBar(
                  percent: detail.percent,
                  status: statusFromPercent(detail.percent),
                  height: 14,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.percent(detail.percent),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 24),
                for (var i = 0; i < detail.units.length; i++) ...[
                  _UnitSection(
                    index: i + 1,
                    unit: detail.units[i],
                    langCode: langCode,
                  ),
                  const SizedBox(height: 20),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _UnitSection extends StatelessWidget {
  const _UnitSection({
    required this.index,
    required this.unit,
    required this.langCode,
  });

  final int index;
  final UnitWithLessons unit;
  final String langCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = pickLang(
        langCode, unit.unit.titleEn, unit.unit.titleUr, unit.unit.titlePs);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l10n.unit(index),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (final lesson in unit.lessons)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: LessonCard(
              title: pickLang(langCode, lesson.titleEn, lesson.titleUr,
                  lesson.titlePs),
              illustration: lesson.illustration,
              completed: unit.completedLessonIds.contains(lesson.id),
              onTap: () => context.push(Routes.lessonPath(lesson.id)),
            ),
          ),
      ],
    );
  }
}
