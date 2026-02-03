import 'package:flutter/material.dart';

import 'package:flutter_application_9/app/theme/app_color_scheme.dart';
import 'package:flutter_application_9/app/theme/app_gradient_scheme.dart';
import 'package:flutter_application_9/app/theme/app_icons.dart';
import 'package:flutter_application_9/app/theme/app_radius.dart';
import 'package:flutter_application_9/app/theme/app_shadows.dart';
import 'package:flutter_application_9/app/theme/app_spacing.dart';
import 'package:flutter_application_9/app/theme/app_text_styles.dart';

class HomeGreetingCard extends StatelessWidget {
  final String title; // مثال: "مرحباً يا عبدالله" / "مرحباً بك يا زائر"
  final String subtitle;

  const HomeGreetingCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradientScheme.primary,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h2.copyWith(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMuted.copyWith(color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // دائرة الأيقونة
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColorScheme.surface.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: AppColorScheme.surface.withValues(alpha: 0.35),
              ),
            ),
            child: const Center(
              child: Icon(AppIcons.student, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
