import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/app_settings.dart';
import '../../shared/services/tts_service.dart';
import '../../shared/utils/localized_text.dart';
import '../../shared/widgets/widgets.dart';

/// A single lesson: objective, explanation, example, illustration, audio, an
/// "I didn't understand" helper sheet, and links to Practice / Start Quiz.
class LessonScreen extends ConsumerStatefulWidget {
  const LessonScreen({super.key, required this.lessonId});
  final int lessonId;

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  bool _markedOpened = false;

  Future<void> _markOpened() async {
    if (_markedOpened) return;
    _markedOpened = true;
    final student = await ref.read(currentStudentProvider.future);
    if (student == null) return;
    await ref
        .read(learningRepositoryProvider)
        .markLessonProgress(student.id, widget.lessonId, completed: false);
    ref.invalidate(subjectProgressListProvider);
    ref.invalidate(continueTargetProvider);
  }

  Future<void> _toggleFavorite(AppLocalizations l10n) async {
    final student = await ref.read(currentStudentProvider.future);
    if (student == null) return;
    final nowFav = await ref
        .read(learningRepositoryProvider)
        .toggleFavorite(student.id, widget.lessonId);
    ref.invalidate(isFavoriteProvider(widget.lessonId));
    ref.invalidate(favoriteLessonsProvider);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(nowFav ? l10n.favoriteAdded : l10n.favoriteRemoved),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final langCode = ref.watch(languageCodeProvider);
    final async = ref.watch(lessonWithSubjectProvider(widget.lessonId));
    final isFav = ref.watch(isFavoriteProvider(widget.lessonId));

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: l10n.favoriteAction,
            icon: Icon(
              (isFav.value ?? false)
                  ? Icons.star_rounded
                  : Icons.star_border_rounded,
              color: (isFav.value ?? false) ? AppColors.yellowDark : null,
            ),
            onPressed: () => _toggleFavorite(l10n),
          ),
        ],
      ),
      body: SafeArea(
        child: async.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(
            onRetry: () =>
                ref.invalidate(lessonWithSubjectProvider(widget.lessonId)),
          ),
          data: (data) {
            if (data == null) {
              return EmptyState(icon: '📖', body: l10n.emptyBody);
            }
            // Record that the lesson was opened (best-effort).
            WidgetsBinding.instance
                .addPostFrameCallback((_) => _markOpened());

            final lesson = data.lesson;
            final subjectName = data.subject == null
                ? ''
                : pickLang(langCode, data.subject!.nameEn,
                    data.subject!.nameUr, data.subject!.namePs);
            final title = pickLang(
                langCode, lesson.titleEn, lesson.titleUr, lesson.titlePs);
            final objective = pickLang(langCode, lesson.objectiveEn,
                lesson.objectiveUr, lesson.objectivePs);
            final explanation = pickLang(langCode, lesson.explanationEn,
                lesson.explanationUr, lesson.explanationPs);
            final example = pickLang(langCode, lesson.exampleEn,
                lesson.exampleUr, lesson.examplePs);

            final readAloud =
                '$title. $objective. $explanation. $example';

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (subjectName.isNotEmpty)
                  Text(subjectName,
                      style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Text(lesson.illustration,
                        style: const TextStyle(fontSize: 40)),
                  ],
                ),
                const SizedBox(height: 8),
                if (lesson.isDemo) const DemoBadge(),
                const SizedBox(height: 16),
                _ObjectiveCard(objective: objective),
                const SizedBox(height: 16),
                _Section(
                  icon: Icons.lightbulb_outline_rounded,
                  title: l10n.sectionExplanation,
                  body: explanation,
                ),
                const SizedBox(height: 12),
                _Section(
                  icon: Icons.format_quote_rounded,
                  title: l10n.sectionExample,
                  body: example,
                ),
                const SizedBox(height: 12),
                _IllustrationCard(emoji: lesson.illustration),
                const SizedBox(height: 20),
                AudioButton(
                  text: readAloud,
                  label: l10n.listenToLesson,
                  filled: true,
                  audioAsset: lesson.audioAsset,
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                  label: l10n.iDidntUnderstand,
                  icon: Icons.help_outline_rounded,
                  onPressed: () => _showHelpSheet(context, readAloud, title,
                      explanation, example),
                ),
                const Divider(height: 40),
                PrimaryButton(
                  label: l10n.startQuiz,
                  icon: Icons.quiz_rounded,
                  onPressed: () =>
                      context.push(Routes.quizPath(widget.lessonId)),
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                  label: l10n.practice,
                  icon: Icons.edit_note_rounded,
                  onPressed: () =>
                      context.push(Routes.quizPath(widget.lessonId)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showHelpSheet(BuildContext context, String readAloud, String title,
      String explanation, String example) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return _HelpSheet(
          lessonId: widget.lessonId,
          title: title,
          explanation: explanation,
          example: example,
          readAloud: readAloud,
          l10n: l10n,
        );
      },
    );
  }
}

class _ObjectiveCard extends StatelessWidget {
  const _ObjectiveCard({required this.objective});
  final String objective;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flag_rounded, color: AppColors.green, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.learningObjective,
                style: const TextStyle(
                  color: AppColors.greenDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(objective, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(body, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class _IllustrationCard extends StatelessWidget {
  const _IllustrationCard({required this.emoji});
  final String emoji;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.blue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 6),
          Text(l10n.sectionIllustration,
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

/// The "I didn't understand" helper. Offers to re-explain more simply, with an
/// example, or in Urdu/Pashto, plus a listen button — a friendly bridge to the
/// AI Tutor without pretending to replace a teacher.
class _HelpSheet extends ConsumerWidget {
  const _HelpSheet({
    required this.lessonId,
    required this.title,
    required this.explanation,
    required this.example,
    required this.readAloud,
    required this.l10n,
  });

  final int lessonId;
  final String title;
  final String explanation;
  final String example;
  final String readAloud;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 4,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.iDidntUnderstand,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          _HelpTile(
            icon: Icons.spa_rounded,
            label: l10n.helpExplainSimply,
            onTap: () => _speakSimplified(context, ref),
          ),
          _HelpTile(
            icon: Icons.emoji_objects_rounded,
            label: l10n.helpExplainWithExample,
            onTap: () => _speak(context, ref, example),
          ),
          _HelpTile(
            icon: Icons.translate_rounded,
            label: l10n.helpExplainInUrdu,
            onTap: () => _speak(context, ref, explanation, code: 'ur'),
          ),
          _HelpTile(
            icon: Icons.translate_rounded,
            label: l10n.helpExplainInPashto,
            onTap: () => _speak(context, ref, explanation, code: 'ps'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: l10n.helpListen,
                  icon: Icons.volume_up_rounded,
                  onPressed: () => _speak(context, ref, readAloud),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: l10n.aiTutorTitle,
                  icon: Icons.smart_toy_rounded,
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push(Routes.aiTutorPath(lessonId: lessonId));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _speak(BuildContext context, WidgetRef ref, String text,
      {String? code}) {
    final lang = code ?? ref.read(settingsControllerProvider).language.code;
    ref.read(ttsServiceProvider).speak(text, languageCode: lang);
  }

  void _speakSimplified(BuildContext context, WidgetRef ref) {
    // A gentle, simplified re-phrasing (mock — no AI API).
    final simplified = '$title. ${explanation.split('.').first}.';
    _speak(context, ref, simplified);
  }
}

class _HelpTile extends StatelessWidget {
  const _HelpTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(label,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.volume_up_rounded),
        onTap: onTap,
      ),
    );
  }
}
