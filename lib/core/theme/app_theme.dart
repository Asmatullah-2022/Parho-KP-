import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Central Material 3 theme for Parho KP.
///
/// Designed for young learners on low-end devices: large text, big touch
/// targets, rounded cards, high contrast. Values are shared between light and
/// dark so the app feels consistent when the theme is switched.
abstract final class AppTheme {
  static const double cardRadius = 20;
  static const double buttonRadius = 16;
  static const double minTouchTarget = 56; // > 48dp accessibility minimum

  static ThemeData light() => _base(Brightness.light);
  static ThemeData dark() => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.green,
      brightness: brightness,
      primary: AppColors.green,
      secondary: AppColors.blue,
      tertiary: AppColors.yellow,
      surface: isDark ? AppColors.surfaceDark : AppColors.white,
    );

    final baseText = Typography.material2021(platform: TargetPlatform.android)
        .black
        .apply(
          bodyColor: scheme.onSurface,
          displayColor: scheme.onSurface,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      textTheme: baseText.copyWith(
        // Slightly larger defaults for readability by children.
        bodyLarge: baseText.bodyLarge?.copyWith(fontSize: 18, height: 1.4),
        bodyMedium: baseText.bodyMedium?.copyWith(fontSize: 16, height: 1.4),
        titleLarge:
            baseText.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.w700),
        headlineSmall: baseText.headlineSmall
            ?.copyWith(fontSize: 26, fontWeight: FontWeight.w700),
        labelLarge:
            baseText.labelLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor:
            isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        foregroundColor: scheme.onSurface,
        titleTextStyle: baseText.titleLarge?.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? AppColors.cardDark : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(minTouchTarget),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(minTouchTarget),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          side: BorderSide(color: scheme.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.cardDark : AppColors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 2,
        backgroundColor: isDark ? AppColors.cardDark : AppColors.white,
        indicatorColor: scheme.primary.withValues(alpha: 0.16),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.5),
      ),
    );
  }
}
