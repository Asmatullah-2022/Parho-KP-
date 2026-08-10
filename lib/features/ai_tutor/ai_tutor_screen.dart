import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/app_settings.dart';
import '../../shared/services/tts_service.dart';
import 'mock_tutor.dart';

class _Msg {
  _Msg(this.text, this.fromAi);
  final String text;
  final bool fromAi;
}

/// A friendly, purpose-built AI Tutor (MOCK). Not a generic chatbot: it opens
/// with a clear role, offers guided actions, and always reminds the student it
/// supports — not replaces — their teacher.
class AiTutorScreen extends ConsumerStatefulWidget {
  const AiTutorScreen({super.key});

  @override
  ConsumerState<AiTutorScreen> createState() => _AiTutorScreenState();
}

class _AiTutorScreenState extends ConsumerState<AiTutorScreen> {
  final _messages = <_Msg>[];
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _thinking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context);
      setState(() => _messages.add(_Msg(l10n.aiTutorIntro, true)));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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

  Future<void> _send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _thinking) return;
    final code = ref.read(settingsControllerProvider).language.code;
    _controller.clear();
    setState(() {
      _messages.add(_Msg(trimmed, false));
      _thinking = true;
    });
    _scrollToEnd();

    // Simulate a brief "thinking" pause (no network call).
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    final reply = MockTutor.reply(trimmed, code);
    setState(() {
      _thinking = false;
      _messages.add(_Msg(reply, true));
    });
    _scrollToEnd();
  }

  void _speakLast() {
    final code = ref.read(settingsControllerProvider).language.code;
    final lastAi = _messages.lastWhere((m) => m.fromAi,
        orElse: () => _Msg('', true));
    if (lastAi.text.isNotEmpty) {
      ref.read(ttsServiceProvider).speak(lastAi.text, languageCode: code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🤖', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(l10n.aiTutorTitle),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _DisclaimerBanner(text: l10n.aiTutorDisclaimer),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  for (final m in _messages) _Bubble(msg: m),
                  if (_thinking)
                    _Bubble(msg: _Msg('…', true), thinking: true),
                ],
              ),
            ),
            _QuickActions(
              onExplain: () => _send(l10n.aiExplainLesson),
              onDidntUnderstand: () => _send(l10n.iDidntUnderstand),
              onVoice: () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                      SnackBar(content: Text(l10n.aiVoiceComingSoon)));
              },
              onListen: _speakLast,
            ),
            _Composer(
              controller: _controller,
              hint: l10n.aiTypeQuestion,
              onSend: () => _send(_controller.text),
            ),
          ],
        ),
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
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.msg, this.thinking = false});
  final _Msg msg;
  final bool thinking;

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
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
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
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onExplain,
    required this.onDidntUnderstand,
    required this.onVoice,
    required this.onListen,
  });
  final VoidCallback onExplain;
  final VoidCallback onDidntUnderstand;
  final VoidCallback onVoice;
  final VoidCallback onListen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          _Chip(icon: Icons.menu_book_rounded, label: l10n.aiExplainLesson, onTap: onExplain),
          _Chip(icon: Icons.help_outline_rounded, label: l10n.iDidntUnderstand, onTap: onDidntUnderstand),
          _Chip(icon: Icons.mic_rounded, label: l10n.aiAskByVoice, onTap: onVoice),
          _Chip(icon: Icons.volume_up_rounded, label: l10n.aiListenAnswer, onTap: onListen),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: Icon(icon, size: 18),
        label: Text(label),
        onPressed: onTap,
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.hint,
    required this.onSend,
  });
  final TextEditingController controller;
  final String hint;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 6,
        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
      ),
      child: Row(
        children: [
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
            width: 56,
            height: 56,
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
