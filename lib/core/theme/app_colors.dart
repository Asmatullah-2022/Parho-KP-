import 'package:flutter/material.dart';

/// Brand palette for Parho KP.
///
/// Educational identity: green (growth/learning), blue (trust/knowledge),
/// white (clarity) with small yellow accents (encouragement). These are
/// original brand colors and do not imitate any official/government branding.
abstract final class AppColors {
  // Primary greens
  static const Color green = Color(0xFF2E7D32); // primary
  static const Color greenLight = Color(0xFF60AD5E);
  static const Color greenDark = Color(0xFF1B5E20);

  // Secondary blues
  static const Color blue = Color(0xFF1565C0); // secondary
  static const Color blueLight = Color(0xFF5E92F3);
  static const Color blueDark = Color(0xFF003C8F);

  // Yellow accent (used sparingly)
  static const Color yellow = Color(0xFFFFC107);
  static const Color yellowDark = Color(0xFFFFA000);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF6F9F6);
  static const Color surfaceDark = Color(0xFF121712);
  static const Color cardDark = Color(0xFF1E241E);

  // Semantic status (paired with icons/text, never color-only)
  static const Color strong = Color(0xFF2E7D32); // green
  static const Color improving = Color(0xFFFFA000); // amber
  static const Color needsPractice = Color(0xFFC62828); // red
}
