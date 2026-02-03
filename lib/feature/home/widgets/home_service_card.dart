import 'package:flutter/material.dart';
import 'package:flutter_application_9/app/theme/app_color_scheme.dart';
import 'package:flutter_application_9/app/theme/app_radius.dart';
import 'package:flutter_application_9/app/theme/app_shadows.dart';
import 'package:flutter_application_9/app/theme/app_spacing.dart';
import 'package:flutter_application_9/app/theme/app_text_styles.dart';

class HomeServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const HomeServiceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        decoration: BoxDecoration(
          color: AppColorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: AppShadows.card,
          border: Border.all(color: AppColorScheme.border),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColorScheme.surfaceMuted,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColorScheme.border),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 44,
                    color: AppColorScheme.brandPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: AppTextStyles.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
