import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/view_models.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/app_settings.dart';
import '../../shared/services/speech_input_service.dart';
import '../../shared/services/tts_service.dart';
import '../../shared/utils/localized_text.dart';
import 'tutor_models.dart';
import 'tutor_service.dart';

/// One conversation entry. When [question] is set the bubble renders tappable
/// options; [answered]/[correct] track the student's response.
class _Msg {
  _Msg(this.text, this.fromAi, {this.question, this.graded = false});
  final String text;
  final bool fromAi;
  final TutorQuestion? question;
  final bool graded;
  int? answered;
  bool? correct;
}

/// Friendly, purpose-built AI Tutor (MOCK backend). Class-aware, multilingual,
/// offline-first. Not a generic chatbot and not a teacher replacement.
class AiTutorScreen extends ConsumerStatefulWidget {
  const AiTutorScreen({super.key, this.lessonId});
  final int? lessonId;

  @override
  ConsumerState<AiTutorScreen> createState() => _AiTutorScreenState();
}

class _AiTutorScreenState extends ConsumerState<AiTutorScreen> {
  final _messages = <_Msg>[];
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  bool _thinking = false;
  bool _loaded = false;
  int? _studentId;
  String _lastUserText = '';
  TutorContext _baseContext = const TutorContext();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final l10n = AppLocalizations.of(context);
    final repo = ref.read(learningRepositoryProvider);
    final student = await repo.currentStudent();
    final code = ref.read(settingsControllerProvider).language.code;

    var ctx = TutorContext(
      studentName: student?.name ?? '',
      grade: student?.grade ?? 5,
      languageCode: code,
    );

    if (widget.lessonId != null) {
      final data = await repo.lessonWithSubject(widget.lessonId!);
      if (data != null) {
        final lessonTitle = pickLang(code, data.lesson.titleEn,
            data.lesson.titleUr, data.lesson.titlePs);
        ctx = TutorContext(
          studentName: student?.name ?? '',
          grade: student?.grade ?? 5,
          languageCode: code,
          subjectName: data.subject == null
              ? null
              : pickLang(code, data.subject!.nameEn, data.subject!.nameUr,
                  data.subject!.namePs),
          lessonId: data.lesson.id,
          lessonTitle: lessonTitle,
          objective: pickLang(code, data.lesson.objectiveEn,
              data.lesson.objectiveUr, data.lesson.objectivePs),
          topic: lessonTitle,
        );
      }
    }

    final history =
        student == null ? <dynamic>[] : await repo.recentTutorMessages(student.id);

    if (!mounted) return;
    setState(() {
      _studentId = student?.id;
      _baseContext = ctx;
      _messages.clear();
      if (history.isEmpty) {
        _messages.add(_Msg(l10n.aiTutorIntro, true));
      } else {
        for (final m in history) {
          _messages.add(_Msg(m.content as String, m.fromAi as bool));
        }
      }
      _loaded = true;
    });
    _scrollToEnd();
  }

  TutorContext _ctx() => _baseContext.copyWith(
      languageCode: ref.read(settingsControllerProvider).language.code);

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _persist(bool fromAi, String text) async {
    if (_studentId != null) {
      await ref
          .read(learningRepositoryProvider)
          .saveTutorMessage(_studentId!, fromAi, text);
    }
  }

  Future<void> _send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _thinking) return;
    _lastUserText = trimmed;
    _controller.clear();
    await _ask(
      userBubble: trimmed,
      request: TutorRequest(context: _ctx(), message: trimmed),
    );
  }

  Future<void> _sendIntent(TutorIntent intent, String label) async {
    if (_thinking) return;
    await _ask(
      userBubble: label,
      request: TutorRequest(
          context: _ctx(), message: _lastUserText, intent: intent),
    );
  }

  Future<void> _ask({
    required String userBubble,
    required TutorRequest request,
  }) async {
    final fallback = AppLocalizations.of(context).errorBody;
    setState(() {
      _messages.add(_Msg(userBubble, false));
      _thinking = true;
    });
    await _persist(false, userBubble);
    _scrollToEnd();

    TutorReply reply;
    try {
      reply = await ref.read(tutorServiceProvider).respond(request);
    } catch (_) {
      reply = TutorReply(text: fallback);
    }
    if (!mounted) return;
    setState(() {
      _thinking = false;
      _messages.add(_Msg(reply.text, true,
          question: reply.question, graded: reply.graded));
    });
    await _persist(true, reply.text);
    _scrollToEnd();
  }

  Future<void> _answer(_Msg msg, int index) async {
    if (msg.answered != null || msg.question == null) return;
    final l10n = AppLocalizations.of(context);
    final correct = index == msg.question!.correctIndex;
    setState(() {
      msg.answered = index;
      msg.correct = correct;
    });

    final feedback = correct ? l10n.aiCorrect : l10n.aiTryAgain;
    setState(() => _messages.add(_Msg(feedback, true)));
    await _persist(true, feedback);

    if (msg.graded && _studentId != null) {
      await ref
          .read(learningRepositoryProvider)
          .saveUnderstandingCheck(_studentId!, _baseContext.lessonId, correct);
      if (_baseContext.lessonId != null) {
        final rec = await ref
            .read(learningRepositoryProvider)
            .adaptiveRecommendation(_studentId!, _baseContext.lessonId!);
        final recText = switch (rec) {
          AdaptiveRecommendation.review => l10n.aiRecReview,
          AdaptiveRecommendation.ready => l10n.aiRecReady,
          AdaptiveRecommendation.keepGoing => l10n.aiRecKeepGoing,
        };
        if (!mounted) return;
        setState(() => _messages.add(_Msg(recText, true)));
        await _persist(true, recText);
      }
    }
    _scrollToEnd();
  }

  Future<void> _clear() async {
    final l10n = AppLocalizations.of(context);
    if (_studentId != null) {
      await ref.read(learningRepositoryProvider).clearTutorMessages(_studentId!);
    }
    if (!mounted) return;
    setState(() {
      _messages
        ..clear()
        ..add(_Msg(l10n.aiTutorIntro, true));
    });
  }

  Future<void> _listen() async {
    final l10n = AppLocalizations.of(context);
    final code = ref.read(settingsControllerProvider).language.code;
    _Msg? lastAi;
    for (final m in _messages.reversed) {
      if (m.fromAi && m.text.isNotEmpty) {
        lastAi = m;
        break;
      }
    }
    if (lastAi == null) return;
    final tts = ref.read(ttsServiceProvider);
    final available = await tts.isLanguageAvailable(code);
    if (!available) {
      _snack(l10n.aiVoiceOutputUnavailable);
      // Still attempt with default voice so something is read aloud.
    }
    await tts.speak(lastAi.text, languageCode: code);
  }

  Future<void> _voice() async {
    final l10n = AppLocalizations.of(context);
    final service = ref.read(speechInputServiceProvider);
    final available = await service.isAvailable();
    if (!available) {
      _snack(l10n.aiVoiceUnavailable);
      return;
    }
    final code = ref.read(settingsControllerProvider).language.code;
    final text = await service.listen(languageCode: code);
    if (text != null && text.trim().isNotEmpty) {
      await _send(text);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final online = ref.watch(connectivityMockProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🤖', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(online ? l10n.aiTutorTitle : l10n.aiOfflineTitle),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.aiClear,
            icon: const Icon(Icons.delete_sweep_rounded),
            onPressed: _messages.isEmpty ? null : _clear,
          ),
        ],
      ),
      body: SafeArea(
        child: !_loaded
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _ContextHeader(context: _baseContext, online: online),
                  _DisclaimerBanner(
                    text: online
                        ? l10n.aiTutorDisclaimer
                        : l10n.aiOfflineHelp,
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length + (_thinking ? 1 : 0),
                      itemBuilder: (context, i) {
                        if (i >= _messages.length) {
                          return _Bubble(msg: _Msg('…', true), thinking: true);
                        }
                        final msg = _messages[i];
                        return _Bubble(
                          msg: msg,
                          onAnswer: msg.question == null
                              ? null
                              : (idx) => _answer(msg, idx),
                        );
                      },
                    ),
                  ),
                  _ActionsBar(
                    onIntent: _sendIntent,
                    onListen: _listen,
                  ),
                  _Composer(
                    controller: _controller,
                    hint: l10n.aiTypeQuestion,
                    onSend: () => _send(_controller.text),
                    onVoice: _voice,
                  ),
                ],
              ),
      ),
    );
  }
}

class _ContextHeader extends StatelessWidget {
  const _ContextHeader({required this.context, required this.online});
  final TutorContext context;
  final bool online;

  @override
  Widget build(BuildContext ctx) {
    final l10n = AppLocalizations.of(ctx);
    final bits = <String>[
      if (context.studentName.isNotEmpty) context.studentName,
      l10n.gradeShort(context.grade),
      if (context.subjectName != null) context.subjectName!,
      if (context.lessonTitle != null) context.lessonTitle!,
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: (online ? AppColors.blue : AppColors.improving)
          .withValues(alpha: 0.10),
      child: Row(
        children: [
          Icon(online ? Icons.wifi_rounded : Icons.wifi_off_rounded,
              size: 18,
              color: online ? AppColors.blue : AppColors.improving),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              bits.join('  ·  '),
              style: Theme.of(ctx)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _DisclaimerBanner extends StatelessWidget {
  const _DisclaimerBanner({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.yellow.withValues(alpha: 0.18),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              size: 18, color: AppColors.yellowDark),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.msg, this.thinking = false, this.onAnswer});
  final _Msg msg;
  final bool thinking;
  final ValueChanged<int>? onAnswer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final align = msg.fromAi ? Alignment.centerLeft : Alignment.centerRight;
    final bg = msg.fromAi
        ? AppColors.blue.withValues(alpha: 0.10)
        : AppColors.green.withValues(alpha: 0.14);

    return Align(
      alignment: align,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.fromAi ? 2 : 16),
            bottomRight: Radius.circular(msg.fromAi ? 16 : 2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.fromAi ? l10n.roleAi : l10n.roleStudent,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: msg.fromAi ? AppColors.blueDark : AppColors.greenDark,
              ),
            ),
            const SizedBox(height: 4),
            thinking
                ? Text(l10n.aiThinking,
                    style: TextStyle(color: scheme.onSurfaceVariant))
                : Text(msg.text,
                    style: Theme.of(context).textTheme.bodyLarge),
            if (msg.question != null) ...[
              const SizedBox(height: 10),
              for (var i = 0; i < msg.question!.options.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _OptionButton(
                    text: msg.question!.options[i],
                    state: msg.answered == null
                        ? _OptState.idle
                        : (i == msg.question!.correctIndex
                            ? _OptState.correct
                            : (i == msg.answered
                                ? _OptState.wrong
                                : _OptState.idle)),
                    onTap: msg.answered == null && onAnswer != null
                        ? () => onAnswer!(i)
                        : null,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

enum _OptState { idle, correct, wrong }

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.text,
    required this.state,
    required this.onTap,
  });
  final String text;
  final _OptState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color border = Theme.of(context).colorScheme.outlineVariant;
    Color bg = Theme.of(context).cardColor;
    Widget? trailing;
    switch (state) {
      case _OptState.correct:
        border = AppColors.green;
        bg = AppColors.green.withValues(alpha: 0.14);
        trailing = const Icon(Icons.check_circle_rounded,
            color: AppColors.green, size: 20);
      case _OptState.wrong:
        border = AppColors.needsPractice;
        bg = AppColors.needsPractice.withValues(alpha: 0.12);
        trailing = const Icon(Icons.cancel_rounded,
            color: AppColors.needsPractice, size: 20);
      case _OptState.idle:
        break;
    }
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(text,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

class _ActionsBar extends StatelessWidget {
  const _ActionsBar({required this.onIntent, required this.onListen});
  final void Function(TutorIntent, String) onIntent;
  final VoidCallback onListen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chips = <(IconData, String, VoidCallback)>[
      (Icons.menu_book_rounded, l10n.aiExplainLesson,
          () => onIntent(TutorIntent.explainLesson, l10n.aiExplainLesson)),
      (Icons.help_outline_rounded, l10n.iDidntUnderstand,
          () => onIntent(TutorIntent.iDontUnderstand, l10n.iDidntUnderstand)),
      (Icons.spa_rounded, l10n.aiExplainSimply,
          () => onIntent(TutorIntent.explainSimply, l10n.aiExplainSimply)),
      (Icons.groups_rounded, l10n.aiExplainForClass,
          () => onIntent(TutorIntent.explainForClass, l10n.aiExplainForClass)),
      (Icons.emoji_objects_rounded, l10n.aiEasyExample,
          () => onIntent(TutorIntent.giveExample, l10n.aiEasyExample)),
      (Icons.quiz_outlined, l10n.aiAskQuestion,
          () => onIntent(TutorIntent.askQuestion, l10n.aiAskQuestion)),
      (Icons.emoji_events_outlined, l10n.aiTestUnderstanding,
          () => onIntent(
              TutorIntent.testUnderstanding, l10n.aiTestUnderstanding)),
      (Icons.autorenew_rounded, l10n.aiExplainAnother,
          () => onIntent(TutorIntent.explainAnother, l10n.aiExplainAnother)),
      (Icons.translate_rounded, l10n.aiTranslate,
          () => onIntent(TutorIntent.translate, l10n.aiTranslate)),
      (Icons.volume_up_rounded, l10n.aiListenAnswer, onListen),
    ];
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final c = chips[i];
          return ActionChip(
            avatar: Icon(c.$1, size: 18),
            label: Text(c.$2),
            onPressed: c.$3,
          );
        },
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.hint,
    required this.onSend,
    required this.onVoice,
  });
  final TextEditingController controller;
  final String hint;
  final VoidCallback onSend;
  final VoidCallback onVoice;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        top: 6,
        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: l10n.aiAskByVoice,
            onPressed: onVoice,
            icon: const Icon(Icons.mic_rounded),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: hint,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 52,
            height: 52,
            child: FilledButton(
              onPressed: onSend,
              style: FilledButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: const CircleBorder(),
              ),
              child: const Icon(Icons.send_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
