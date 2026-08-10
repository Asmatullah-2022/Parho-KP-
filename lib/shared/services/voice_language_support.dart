/// Central description of which app languages voice features target, and how
/// app language codes map to device locale hints. Keeps speech-input and
/// text-to-speech services consistent and easy to extend.
abstract final class VoiceLanguageSupport {
  /// App language codes the app aims to support for voice (in and out).
  static const supported = ['en', 'ur', 'ps'];

  /// Device locale hints for TTS / STT per app language.
  static const localeHints = {
    'en': 'en-US',
    'ur': 'ur-PK',
    'ps': 'ps-AF',
  };

  static bool isSupported(String code) => supported.contains(code);

  static String localeHint(String code) => localeHints[code] ?? 'en-US';

  /// Human-readable display name for a language code.
  static String displayName(String code) => switch (code) {
        'ur' => 'اردو',
        'ps' => 'پښتو',
        _ => 'English',
      };
}
