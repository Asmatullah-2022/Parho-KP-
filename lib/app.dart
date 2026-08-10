import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'shared/providers/app_settings.dart';

/// Provides default Cupertino localizations for any locale whose translations
/// are not bundled (e.g. Pashto), so Cupertino widgets never crash the app.
class _FallbackCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _FallbackCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(_FallbackCupertinoLocalizationsDelegate old) => false;
}

/// Root widget: wires the router, theme (light/dark/system), locale and the
/// app-wide font-size scale.
class ParhoKpApp extends ConsumerWidget {
  const ParhoKpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsControllerProvider);

    return MaterialApp.router(
      title: 'Parho KP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      locale: settings.language.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        // Pashto (ps) has no bundled Cupertino translations; fall back to the
        // default so the app never throws an "unsupported locale" error.
        _FallbackCupertinoLocalizationsDelegate(),
      ],
      routerConfig: router,
      builder: (context, child) {
        // Apply the user's font-size preference app-wide, clamped so layouts
        // never break, and respect any additional OS accessibility scaling.
        final media = MediaQuery.of(context);
        final scale = settings.fontSize.scale;
        return MediaQuery(
          data: media.copyWith(
            textScaler: TextScaler.linear(scale).clamp(
              minScaleFactor: 0.8,
              maxScaleFactor: 1.6,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
