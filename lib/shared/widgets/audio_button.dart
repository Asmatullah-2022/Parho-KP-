import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_settings.dart';
import '../services/tts_service.dart';

/// Button that reads the given [text] aloud using on-device TTS.
///
/// Respects the "Audio" setting and the active language. Shown as a pill with a
/// speaker icon and label.
class AudioButton extends ConsumerWidget {
  const AudioButton({
    super.key,
    required this.text,
    required this.label,
    this.filled = false,
  });

  final String text;
  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioEnabled =
        ref.watch(settingsControllerProvider.select((s) => s.audioEnabled));
    final languageCode = ref.watch(
      settingsControllerProvider.select((s) => s.language.code),
    );

    void onPressed() {
      if (!audioEnabled) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('🔇')),
          );
        return;
      }
      ref.read(ttsServiceProvider).speak(text, languageCode: languageCode);
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
