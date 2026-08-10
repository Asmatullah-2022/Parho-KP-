import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/utils/localized_text.dart';
import '../../shared/widgets/widgets.dart';

/// Child-friendly quiz: one question at a time, large options, immediate
/// feedback, then persists the attempt and routes to the result screen.
class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key, required this.lessonId});
  final int lessonId;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _index = 0;
  bool _revealed = false;
  List<int> _selected = const [];
  bool _submitting = false;

  List<String> _options(String code, Question q) {
    final raw = code == 'ur'
        ? q.optionsUr
        : code == 'ps'
            ? q.optionsPs
            : q.optionsEn;
    final decoded = (jsonDecode(raw) as List).cast<String>();
    return decoded;
  }

  Future<void> _finish(List<Question> questions) async {
    setState(() => _submitting = true);
    final student = await ref.read(currentStudentProvider.future);
    if (student == null) return;
    final attemptId =
        await ref.read(learningRepositoryProvider).saveQuizResult(
              studentId: student.id,
              lessonId: widget.lessonId,
              questions: questions,
              selected: _selected,
            );
    ref.invalidate(subjectProgressListProvider);
    ref.invalidate(overallPercentProvider);
    ref.invalidate(continueTargetProvider);
    if (!mounted) return;
    context.pushReplacement(Routes.quizResultPath(attemptId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final code = ref.watch(languageCodeProvider);
    final questionsAsync = ref.watch(lessonQuestionsProvider(widget.lessonId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tileQuiz)),
      body: SafeArea(
        child: questionsAsync.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(
            onRetry: () =>
                ref.invalidate(lessonQuestionsProvider(widget.lessonId)),
          ),
          data: (questions) {
            if (questions.isEmpty) {
              return EmptyState(icon: '📝', body: l10n.quizNoQuestions);
            }
            if (_selected.length != questions.length) {
              _selected = List<int>.filled(questions.length, -1);
            }
            final q = questions[_index];
            final options = _options(code, q);
            final prompt =
                pickLang(code, q.promptEn, q.promptUr, q.promptPs);
            final isLast = _index == questions.length - 1;
            final answered = _selected[_index] != -1;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.questionProgress(
                                _index + 1, questions.length),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          if (q.correctIndex >= 0)
                            const Icon(Icons.help_outline_rounded),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (_index + 1) / questions.length,
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Text(
                        prompt,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 20),
                      for (var i = 0; i < options.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: QuizOption(
                            text: options[i],
                            selected: _selected[_index] == i,
                            revealed: _revealed,
                            isCorrect: i == q.correctIndex,
                            onTap: _revealed
                                ? null
                                : () => setState(() {
                                      _selected[_index] = i;
                                      _revealed = true;
                                    }),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: PrimaryButton(
                    label: isLast ? l10n.actionDone : l10n.actionNext,
                    icon: isLast
                        ? Icons.check_rounded
                        : Icons.arrow_forward_rounded,
                    onPressed: (!answered || _submitting)
                        ? null
                        : () {
                            if (isLast) {
                              _finish(questions);
                            } else {
                              setState(() {
                                _index++;
                                _revealed = _selected[_index] != -1;
                              });
                            }
                          },
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
