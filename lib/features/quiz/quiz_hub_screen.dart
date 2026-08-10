import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/utils/localized_text.dart';
import '../../shared/widgets/widgets.dart';

/// The Quiz tab: pick any lesson to start its quiz.
class QuizHubScreen extends ConsumerWidget {
  const QuizHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final code = ref.watch(languageCodeProvider);
    final async = ref.watch(lessonsBySubjectProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tileQuiz)),
      body: SafeArea(
        child: async.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(
            onRetry: () => ref.invalidate(lessonsBySubjectProvider),
          ),
          data: (groups) {
            final nonEmpty =
                groups.where((g) => g.lessons.isNotEmpty).toList();
            if (nonEmpty.isEmpty) {
              return EmptyState(icon: '📝', body: l10n.quizNoQuestions);
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final group in nonEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
                    child: Row(
                      children: [
                        Text(group.subject.emoji,
                            style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text(
                          pickLang(code, group.subject.nameEn,
                              group.subject.nameUr, group.subject.namePs),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  for (final lesson in group.lessons)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: LessonCard(
                        title: pickLang(code, lesson.titleEn, lesson.titleUr,
                            lesson.titlePs),
                        subtitle: l10n.startQuiz,
                        illustration: lesson.illustration,
                        completed: false,
                        onTap: () =>
                            context.push(Routes.quizPath(lesson.id)),
                      ),
                    ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
