import 'package:flutter/material.dart';
import 'app_color_scheme.dart';
import 'app_text_styles.dart';
import 'app_radius.dart';

abstract class AppTheme {
  static ThemeData lightTheme = ThemeData(
    // ===============================
    // General
    // ===============================
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColorScheme.mainbackgroun,
    fontFamily: 'Tajawal',

    // ===============================
    // Color Scheme
    // ===============================
    colorScheme: const ColorScheme.light(
      primary: AppColorScheme.brandPrimary,
      secondary: AppColorScheme.brandSecondary,
      surface: AppColorScheme.surface,
      error: AppColorScheme.danger,
    ),

    // ===============================
    // AppBar
    // ===============================
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColorScheme.surface,
      foregroundColor: AppColorScheme.textPrimary,
      titleTextStyle: AppTextStyles.h2,
    ),

    // ===============================
    // Text Theme
    // ===============================
    textTheme: const TextTheme(
      headlineLarge: AppTextStyles.h1,
      headlineMedium: AppTextStyles.h2,
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.bodyMuted,
      labelMedium: AppTextStyles.label,
    ),

    // ===============================
    // Buttons
    // ===============================
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        backgroundColor: AppColorScheme.brandPrimary,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),

    // ===============================
    // Input Fields
    // ===============================
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColorScheme.surface,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.button),
        borderSide: const BorderSide(color: AppColorScheme.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.button),
        borderSide: const BorderSide(color: AppColorScheme.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.button),
        borderSide: const BorderSide(
          color: AppColorScheme.brandPrimary,
          width: 1.5,
        ),
      ),
    ),

    // ===============================
    // Divider
    // ===============================
    dividerTheme: const DividerThemeData(
      color: AppColorScheme.border,
      thickness: 1,
    ),
  );


  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0B1220),
    fontFamily: 'Tajawal',
    colorScheme: const ColorScheme.dark(
      primary: AppColorScheme.brandPrimary,
      secondary: AppColorScheme.brandSecondary,
      surface: Color(0xFF0F172A),
      error: AppColorScheme.danger,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Color(0xFF0F172A),
      foregroundColor: Colors.white,
      titleTextStyle: AppTextStyles.h2,
    ),
    textTheme: const TextTheme(
      headlineLarge: AppTextStyles.h1,
      headlineMedium: AppTextStyles.h2,
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.bodyMuted,
      labelMedium: AppTextStyles.label,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        backgroundColor: AppColorScheme.brandPrimary,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );

}
