import 'package:flutter/material.dart';
import 'app_color_scheme.dart';

/// جميع TextStyles الرسمية للتطبيق
abstract class AppTextStyles {
  // ===============================
  // Headings (Cairo)
  // ===============================
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColorScheme.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColorScheme.textPrimary,
  );

  // ===============================
  // Body (Tajawal)
  // ===============================
  static const TextStyle body = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColorScheme.textPrimary,
  );

  static const TextStyle bodyMuted = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 14,
    color: AppColorScheme.textSecondary,
  );

  // ===============================
  // Labels & Meta
  // ===============================
  static const TextStyle label = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColorScheme.textSecondary,
  );
}
