import 'package:flutter/material.dart';
import 'package:flutter_application_9/app/navigation/main_bottom_nav.dart';
import 'package:flutter_application_9/app/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainBottomNav(),
    );
  }
}

// // ignore: unused_element
// class _BootstrapPage extends StatelessWidget {
//   const _BootstrapPage();

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: Text('University Guide - Bootstrapped')),
//     );
//   }
// }
