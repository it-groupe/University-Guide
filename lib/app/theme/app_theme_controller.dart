import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode theme_mode = ThemeMode.light;

  bool get is_dark => theme_mode == ThemeMode.dark;

  void set_dark(bool value) {
    final next = value ? ThemeMode.dark : ThemeMode.light;
    if (next == theme_mode) return;
    theme_mode = next;
    notifyListeners();
  }
}
