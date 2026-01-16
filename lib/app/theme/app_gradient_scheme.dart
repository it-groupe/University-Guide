import 'package:flutter/material.dart';
import 'app_color_scheme.dart';

abstract class AppGradientScheme {
  static const LinearGradient primary = LinearGradient(
    colors: [AppColorScheme.brandPrimary, AppColorScheme.brandSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient success = LinearGradient(
    colors: [Color(0xFF16A34A), Color(0xFF4ADE80)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
