import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/content/content_delivery_providers.dart';
import '../providers/app_settings.dart';
import '../services/tts_service.dart';

/// Button that reads the given [text] aloud.
///
/// If [audioAsset] points to a downloaded offline audio file, that file is
/// played; otherwise it falls back to on-device TTS. Respects the "Audio"
/// setting and the active language. Works fully offline once content is
/// installed.
class AudioButton extends ConsumerWidget {
  const AudioButton({
    super.key,
    required this.text,
    required this.label,
    this.filled = false,
    this.audioAsset,
  });

  final String text;
  final String label;
  final bool filled;

  /// Optional stored audio path (e.g. `grade5_math_ur_v1/audio/lesson_100.mp3`).
  final String? audioAsset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioEnabled =
        ref.watch(settingsControllerProvider.select((s) => s.audioEnabled));
    final languageCode = ref.watch(
      settingsControllerProvider.select((s) => s.language.code),
    );

    Future<void> onPressed() async {
      if (!audioEnabled) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('🔇')));
        return;
      }
      // Prefer a downloaded offline audio file; fall back to TTS.
      if (audioAsset != null && audioAsset!.isNotEmpty) {
        final abs =
            await ref.read(audioStoreProvider).resolve(audioAsset!);
        await ref.read(lessonAudioServiceProvider).play(
              text: text,
              audioAsset: abs,
              languageCode: languageCode,
            );
      } else {
        await ref.read(ttsServiceProvider).speak(text, languageCode: languageCode);
      }
    }

    if (filled) {
      return FilledButton.tonalIcon(
        onPressed: onPressed,
        icon: const Icon(Icons.volume_up_rounded),
        label: Text(label),
      );
    }
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.volume_up_rounded),
      label: Text(label),
    );
  }
}
