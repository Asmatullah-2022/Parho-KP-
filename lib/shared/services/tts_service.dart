import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Maps app language codes to TTS locale hints. Availability depends on the
/// device's installed voices; we fail gracefully when a voice is missing.
const _ttsLocales = {
  'en': 'en-US',
  'ur': 'ur-PK',
  'ps': 'ps-AF',
};

/// Reads text aloud (voice output). Abstracted so the implementation can change
/// without touching callers, and so a language's availability can be checked to
/// show a friendly message instead of failing silently.
abstract class TextToSpeechService {
  Future<void> speak(String text, {String languageCode = 'en'});
  Future<void> stop();
  Future<bool> isLanguageAvailable(String languageCode);
}

/// Thin wrapper around [FlutterTts] so lessons and answers can be read aloud.
///
/// This powers the "Audio Learning" feature fully on-device — no network, no
/// bundled audio files, so it works offline and uses no bandwidth.
class TtsService implements TextToSpeechService {
  TtsService() {
    _init();
  }

  final FlutterTts _tts = FlutterTts();
  bool _ready = false;

  Future<void> _init() async {
    try {
      await _tts.setSpeechRate(0.45); // slower — easier for children
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      _ready = true;
    } catch (e) {
      // TTS engine unavailable (e.g. on a host during tests) — ignore.
      debugPrint('TTS init failed: $e');
    }
  }

  @override
  Future<void> speak(String text, {String languageCode = 'en'}) async {
    if (!_ready || text.trim().isEmpty) return;
    try {
      final locale = _ttsLocales[languageCode] ?? 'en-US';
      await _tts.stop();
      await _tts.setLanguage(locale);
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS speak failed: $e');
    }
  }

  /// Whether the device has a voice for the given app language. Failing checks
  /// return false so the UI can show a friendly message rather than crash.
  @override
  Future<bool> isLanguageAvailable(String languageCode) async {
    try {
      final locale = _ttsLocales[languageCode] ?? 'en-US';
      final result = await _tts.isLanguageAvailable(locale);
      return result == true || result == 1;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }

  void dispose() {
    _tts.stop();
  }
}

final ttsServiceProvider = Provider<TtsService>((ref) {
  final service = TtsService();
  ref.onDispose(service.dispose);
  return service;
});
