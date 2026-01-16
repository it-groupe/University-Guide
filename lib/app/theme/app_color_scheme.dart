import 'package:flutter/material.dart';

/// جميع الألوان الرسمية للتطبيق (Design Tokens)
abstract class AppColorScheme {
  // ===============================
  // Brand
  // ===============================
  static const Color brandPrimary = Color(0xFF2F6FED);
  static const Color brandSecondary = Color(0xFF14B8A6);

  // ===============================
  // mainbackgrouns & Surfaces
  // ===============================
  static const Color mainbackgroun = Color.fromARGB(255, 232, 239, 252);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F5F9);

  // ===============================
  // Text
  // ===============================
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textDisabled = Color(0xFF94A3B8);

  // ===============================
  // Borders & Divider
  // ===============================
  static const Color border = Color(0xFFE2E8F0);

  // ===============================
  // States
  // ===============================
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
}
