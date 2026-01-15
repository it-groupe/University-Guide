import 'package:flutter/material.dart';
import '../design/app_color_scheme.dart';
import '../design/app_text_styles.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? bottomNavigationBar;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorScheme.mainbackgroun,
      appBar: AppBar(
        title: Text(title, style: AppTextStyles.h2),
        backgroundColor: AppColorScheme.surface,
        centerTitle: true,
        elevation: 0,
      ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
