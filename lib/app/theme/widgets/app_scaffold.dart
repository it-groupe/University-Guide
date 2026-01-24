import 'package:flutter/material.dart';
import 'package:flutter_application_9/app/theme/app_color_scheme.dart';
import 'package:flutter_application_9/app/theme/app_text_styles.dart';

class AppScaffold extends StatelessWidget {
  final String? title;

  final PreferredSizeWidget? appBar;

  final Widget body;
  final List<Widget>? actions;
  final Widget? leading;

  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool centerTitle;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.leading,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.centerTitle = true,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget? resolvedAppBar =
        appBar ??
        (title == null
            ? null
            : AppBar(
                title: Text(title!, style: AppTextStyles.h1),
                centerTitle: centerTitle,
                elevation: 0,
                backgroundColor: AppColorScheme.surface,
                foregroundColor: AppColorScheme.textPrimary,
                leading: leading,
                actions: actions,
              ));

    return Scaffold(
      appBar: resolvedAppBar,
      body: body,
      backgroundColor: AppColorScheme.mainbackgroun,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
