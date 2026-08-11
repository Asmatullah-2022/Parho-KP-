import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The three supported UI languages.
enum AppLanguage {
  english('en', TextDirection.ltr),
  urdu('ur', TextDirection.rtl),
  pashto('ps', TextDirection.rtl);

  const AppLanguage(this.code, this.direction);
  final String code;
  final TextDirection direction;

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (l) => l.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}

/// Font-size preference. Maps to a text scale factor applied app-wide.
enum AppFontSize {
  small(0.9),
  medium(1.0),
  large(1.2);

  const AppFontSize(this.scale);
  final double scale;
}

/// Immutable snapshot of all app-level preferences.
@immutable
class AppSettings {
  const AppSettings({
    this.language = AppLanguage.english,
    this.themeMode = ThemeMode.light,
    this.fontSize = AppFontSize.medium,
    this.onboardingComplete = false,
    this.hasProfile = false,
    this.audioEnabled = true,
    this.downloadOnWifiOnly = true,
    this.allowMobileDataDownloads = false,
    this.autoCheckUpdates = true,
    this.offlineMode = false,
  });

  final AppLanguage language;
  final ThemeMode themeMode;
  final AppFontSize fontSize;
  final bool onboardingComplete;
  final bool hasProfile;
  final bool audioEnabled;

  /// Wi-Fi-only downloads. Default ON — the app never silently uses mobile data.
  final bool downloadOnWifiOnly;

  /// Explicit opt-in to downloading over mobile data. Default OFF.
  final bool allowMobileDataDownloads;

  /// Automatically check the catalog for content updates when appropriate.
  /// Default ON (checks are lightweight; large downloads are never automatic).
  final bool autoCheckUpdates;
  final bool offlineMode;

  AppSettings copyWith({
    AppLanguage? language,
    ThemeMode? themeMode,
    AppFontSize? fontSize,
    bool? onboardingComplete,
    bool? hasProfile,
    bool? audioEnabled,
    bool? downloadOnWifiOnly,
    bool? allowMobileDataDownloads,
    bool? autoCheckUpdates,
    bool? offlineMode,
  }) {
    return AppSettings(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      hasProfile: hasProfile ?? this.hasProfile,
      audioEnabled: audioEnabled ?? this.audioEnabled,
      downloadOnWifiOnly: downloadOnWifiOnly ?? this.downloadOnWifiOnly,
      allowMobileDataDownloads:
          allowMobileDataDownloads ?? this.allowMobileDataDownloads,
      autoCheckUpdates: autoCheckUpdates ?? this.autoCheckUpdates,
      offlineMode: offlineMode ?? this.offlineMode,
    );
  }
}

/// Provides the [SharedPreferences] instance. Overridden in `main()` after the
/// async load so the rest of the app can read settings synchronously.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

/// Keys used to persist preferences.
abstract final class _PrefKeys {
  static const language = 'language';
  static const themeMode = 'themeMode';
  static const fontSize = 'fontSize';
  static const onboardingComplete = 'onboardingComplete';
  static const hasProfile = 'hasProfile';
  static const audioEnabled = 'audioEnabled';
  static const downloadOnWifiOnly = 'downloadOnWifiOnly';
  static const allowMobileDataDownloads = 'allowMobileDataDownloads';
  static const autoCheckUpdates = 'autoCheckUpdates';
  static const offlineMode = 'offlineMode';
}

/// Reads/writes [AppSettings] backed by [SharedPreferences].
class SettingsController extends StateNotifier<AppSettings> {
  SettingsController(this._prefs) : super(_load(_prefs));

  final SharedPreferences _prefs;

  static AppSettings _load(SharedPreferences prefs) {
    return AppSettings(
      language: AppLanguage.fromCode(prefs.getString(_PrefKeys.language)),
      themeMode: ThemeMode.values.firstWhere(
        (m) => m.name == prefs.getString(_PrefKeys.themeMode),
        orElse: () => ThemeMode.light,
      ),
      fontSize: AppFontSize.values.firstWhere(
        (f) => f.name == prefs.getString(_PrefKeys.fontSize),
        orElse: () => AppFontSize.medium,
      ),
      onboardingComplete: prefs.getBool(_PrefKeys.onboardingComplete) ?? false,
      hasProfile: prefs.getBool(_PrefKeys.hasProfile) ?? false,
      audioEnabled: prefs.getBool(_PrefKeys.audioEnabled) ?? true,
      downloadOnWifiOnly: prefs.getBool(_PrefKeys.downloadOnWifiOnly) ?? true,
      allowMobileDataDownloads:
          prefs.getBool(_PrefKeys.allowMobileDataDownloads) ?? false,
      autoCheckUpdates: prefs.getBool(_PrefKeys.autoCheckUpdates) ?? true,
      offlineMode: prefs.getBool(_PrefKeys.offlineMode) ?? false,
    );
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = state.copyWith(language: language);
    await _prefs.setString(_PrefKeys.language, language.code);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _prefs.setString(_PrefKeys.themeMode, mode.name);
  }

  Future<void> setFontSize(AppFontSize size) async {
    state = state.copyWith(fontSize: size);
    await _prefs.setString(_PrefKeys.fontSize, size.name);
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(onboardingComplete: true);
    await _prefs.setBool(_PrefKeys.onboardingComplete, true);
  }

  Future<void> setHasProfile(bool value) async {
    state = state.copyWith(hasProfile: value);
    await _prefs.setBool(_PrefKeys.hasProfile, value);
  }

  Future<void> setAudioEnabled(bool value) async {
    state = state.copyWith(audioEnabled: value);
    await _prefs.setBool(_PrefKeys.audioEnabled, value);
  }

  Future<void> setDownloadOnWifiOnly(bool value) async {
    state = state.copyWith(downloadOnWifiOnly: value);
    await _prefs.setBool(_PrefKeys.downloadOnWifiOnly, value);
  }

  Future<void> setAllowMobileDataDownloads(bool value) async {
    state = state.copyWith(allowMobileDataDownloads: value);
    await _prefs.setBool(_PrefKeys.allowMobileDataDownloads, value);
  }

  Future<void> setAutoCheckUpdates(bool value) async {
    state = state.copyWith(autoCheckUpdates: value);
    await _prefs.setBool(_PrefKeys.autoCheckUpdates, value);
  }

  Future<void> setOfflineMode(bool value) async {
    state = state.copyWith(offlineMode: value);
    await _prefs.setBool(_PrefKeys.offlineMode, value);
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, AppSettings>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsController(prefs);
});

/// Simulated connectivity flag. Real connectivity detection is out of scope for
/// this offline-first demo; the user can also force Offline Mode from Settings.
final connectivityMockProvider = StateProvider<bool>((ref) {
  // Consider the app "online" unless the user forced offline mode.
  return !ref.watch(
    settingsControllerProvider.select((s) => s.offlineMode),
  );
});
