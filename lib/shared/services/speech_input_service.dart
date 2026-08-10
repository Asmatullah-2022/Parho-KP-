import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Voice input (speech-to-text) abstraction.
///
/// The UI depends only on this interface. Today no on-device recognizer is
/// bundled, so [UnavailableSpeechInputService] reports unavailable and the UI
/// shows a friendly message. A future implementation for English/Urdu/Pashto
/// can be dropped in by overriding [speechInputServiceProvider] — no UI change.
abstract class SpeechInputService {
  /// Whether speech recognition can be used right now.
  Future<bool> isAvailable();

  /// Listens and returns recognized text, or null if nothing was captured or
  /// recognition is unavailable. [languageCode] is 'en' | 'ur' | 'ps'.
  Future<String?> listen({String languageCode = 'en'});
}

/// Safe default: recognition is not available. Never throws; the mic button
/// falls back to typed input.
class UnavailableSpeechInputService implements SpeechInputService {
  const UnavailableSpeechInputService();

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<String?> listen({String languageCode = 'en'}) async => null;
}

final speechInputServiceProvider = Provider<SpeechInputService>(
  (ref) => const UnavailableSpeechInputService(),
);
