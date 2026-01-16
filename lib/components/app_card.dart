import 'package:flutter/material.dart';
import '../app/theme/app_color_scheme.dart';
import '../app/theme/app_radius.dart';
import '../app/theme/app_shadows.dart';
import '../app/theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppShadows.card,
        border: Border.all(color: AppColorScheme.border),
      ),
      child: child,
    );
  }
}
