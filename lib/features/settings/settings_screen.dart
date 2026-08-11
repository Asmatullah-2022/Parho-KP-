import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/app_settings.dart';

/// App settings: language, font size, audio, Wi-Fi downloads, theme, offline
/// mode, storage, privacy and about.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    String languageName() {
      switch (settings.language) {
        case AppLanguage.english:
          return l10n.languageEnglish;
        case AppLanguage.urdu:
          return l10n.languageUrdu;
        case AppLanguage.pashto:
          return l10n.languagePashto;
      }
    }

    String themeName() {
      switch (settings.themeMode) {
        case ThemeMode.light:
          return l10n.themeLight;
        case ThemeMode.dark:
          return l10n.themeDark;
        case ThemeMode.system:
          return l10n.themeSystem;
      }
    }

    String fontName() {
      switch (settings.fontSize) {
        case AppFontSize.small:
          return l10n.fontSmall;
        case AppFontSize.medium:
          return l10n.fontMedium;
        case AppFontSize.large:
          return l10n.fontLarge;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.translate_rounded),
              title: Text(l10n.languageLabel),
              subtitle: Text(languageName()),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('${Routes.language}?from=settings'),
            ),
            ListTile(
              leading: const Icon(Icons.format_size_rounded),
              title: Text(l10n.settingsFontSize),
              subtitle: Text(fontName()),
              onTap: () => _pickFontSize(context, ref, l10n),
            ),
            const Divider(height: 1),
            SwitchListTile(
              secondary: const Icon(Icons.volume_up_rounded),
              title: Text(l10n.settingsAudio),
              subtitle: Text(l10n.settingsAudioSubtitle),
              value: settings.audioEnabled,
              onChanged: controller.setAudioEnabled,
            ),
            SwitchListTile(
              secondary: const Icon(Icons.wifi_rounded),
              title: Text(l10n.settingsDownloadWifi),
              value: settings.downloadOnWifiOnly,
              onChanged: controller.setDownloadOnWifiOnly,
            ),
            SwitchListTile(
              secondary: const Icon(Icons.signal_cellular_alt_rounded),
              title: Text(l10n.settingsMobileDataDownloads),
              value: settings.allowMobileDataDownloads,
              onChanged: controller.setAllowMobileDataDownloads,
            ),
            SwitchListTile(
              secondary: const Icon(Icons.system_update_rounded),
              title: Text(l10n.settingsAutoCheckUpdates),
              value: settings.autoCheckUpdates,
              onChanged: controller.setAutoCheckUpdates,
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2_rounded),
              title: Text(l10n.contentPackagesTitle),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(Routes.contentPackages),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.cloud_off_rounded),
              title: Text(l10n.settingsOfflineMode),
              subtitle: Text(l10n.settingsOfflineSubtitle),
              value: settings.offlineMode,
              onChanged: controller.setOfflineMode,
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6_rounded),
              title: Text(l10n.settingsDarkMode),
              subtitle: Text(themeName()),
              onTap: () => _pickTheme(context, ref, l10n),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.sd_storage_rounded),
              title: Text(l10n.settingsStorage),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(Routes.offline),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_rounded),
              title: Text(l10n.settingsPrivacy),
              onTap: () => _showInfo(
                  context, l10n.settingsPrivacy, l10n.privacyBody),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: Text(l10n.settingsAbout),
              onTap: () =>
                  _showInfo(context, l10n.settingsAbout, l10n.aboutBody),
            ),
          ],
        ),
      ),
    );
  }

  void _pickFontSize(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final current = ref.read(settingsControllerProvider).fontSize;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => RadioGroup<AppFontSize>(
        groupValue: current,
        onChanged: (v) {
          if (v != null) {
            ref.read(settingsControllerProvider.notifier).setFontSize(v);
          }
          Navigator.of(context).pop();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final size in AppFontSize.values)
              RadioListTile<AppFontSize>(
                value: size,
                title: Text(switch (size) {
                  AppFontSize.small => l10n.fontSmall,
                  AppFontSize.medium => l10n.fontMedium,
                  AppFontSize.large => l10n.fontLarge,
                }),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _pickTheme(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final current = ref.read(settingsControllerProvider).themeMode;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => RadioGroup<ThemeMode>(
        groupValue: current,
        onChanged: (v) {
          if (v != null) {
            ref.read(settingsControllerProvider.notifier).setThemeMode(v);
          }
          Navigator.of(context).pop();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final mode in ThemeMode.values)
              RadioListTile<ThemeMode>(
                value: mode,
                title: Text(switch (mode) {
                  ThemeMode.light => l10n.themeLight,
                  ThemeMode.dark => l10n.themeDark,
                  ThemeMode.system => l10n.themeSystem,
                }),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showInfo(BuildContext context, String title, String body) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.actionClose),
          ),
        ],
      ),
    );
  }
}
