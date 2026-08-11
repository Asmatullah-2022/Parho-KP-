import 'package:flutter/foundation.dart';

import 'tts_service.dart';
import 'voice_language_support.dart';

/// How a lesson was (or would be) played aloud.
enum AudioSource {
  /// A compressed audio file bundled with a downloaded package was used.
  bundledFile,

  /// On-device text-to-speech was used (default, no bandwidth).
  tts,

  /// Neither was available — the caller should show a friendly message.
  unavailable,
}

/// The outcome of a play request, so the UI can react (e.g. show a note when
/// audio is unavailable for a language) without anything throwing.
class AudioPlayResult {
  const AudioPlayResult(this.source, {this.languageCode = 'en'});
  final AudioSource source;
  final String languageCode;

  bool get didPlay => source != AudioSource.unavailable;
}

/// Plays a lesson's audio, preferring a bundled offline audio file when the
/// downloaded package includes one and falling back to on-device TTS otherwise.
///
/// Offline-first: bundled audio needs no network; TTS needs no network or
/// bandwidth. If neither can play (e.g. no TTS voice for the language on this
/// device) it reports [AudioSource.unavailable] gracefully — it never throws.
class LessonAudioService {
  LessonAudioService({
    required this.tts,
    BundledAudioPlayer? filePlayer,
  }) : filePlayer = filePlayer ?? const NoopBundledAudioPlayer();

  final TextToSpeechService tts;

  /// Plays a bundled audio asset by path. Null/unconfigured means "no file
  /// playback available" and the service falls back to TTS.
  final BundledAudioPlayer filePlayer;

  /// Plays [text] for a lesson. If [audioAsset] is a non-empty path and a
  /// bundled player is available, the file is played; otherwise TTS is used.
  Future<AudioPlayResult> play({
    required String text,
    String? audioAsset,
    String languageCode = 'en',
  }) async {
    // 1) Bundled offline audio, if the package shipped one.
    if (audioAsset != null &&
        audioAsset.trim().isNotEmpty &&
        filePlayer.isAvailable) {
      try {
        final ok = await filePlayer.playAsset(audioAsset);
        if (ok) {
          return AudioPlayResult(AudioSource.bundledFile,
              languageCode: languageCode);
        }
      } catch (e) {
        debugPrint('Bundled audio failed, falling back to TTS: $e');
      }
    }

    // 2) On-device TTS fallback (only if a voice exists for the language).
    if (!VoiceLanguageSupport.isSupported(languageCode)) {
      return AudioPlayResult(AudioSource.unavailable,
          languageCode: languageCode);
    }
    final available = await tts.isLanguageAvailable(languageCode);
    if (!available) {
      return AudioPlayResult(AudioSource.unavailable,
          languageCode: languageCode);
    }
    await tts.speak(text, languageCode: languageCode);
    return AudioPlayResult(AudioSource.tts, languageCode: languageCode);
  }

  Future<void> stop() => tts.stop();
}

/// Plays a bundled audio asset (from a downloaded package). Kept behind an
/// interface so a real player (e.g. just_audio) can be added later without
/// changing lesson code. Not wired to a plugin today to keep the app light.
abstract class BundledAudioPlayer {
  bool get isAvailable;
  Future<bool> playAsset(String assetPath);
}

/// Default: no bundled-file playback (the app uses TTS). Reports unavailable so
/// callers cleanly fall back.
class NoopBundledAudioPlayer implements BundledAudioPlayer {
  const NoopBundledAudioPlayer();
  @override
  bool get isAvailable => false;
  @override
  Future<bool> playAsset(String assetPath) async => false;
}
