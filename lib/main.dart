import 'package:flutter/material.dart';
import 'package:flutter_application_9/components/botton_page.dart';
import 'design/app_theme.dart';
import 'screens/demo_screen.dart';
import 'screens/theme_playground_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const ThemePlaygroundScreen(),
      routes: {'botonpage': (context) => BottonPage()},
    );
  }
}
