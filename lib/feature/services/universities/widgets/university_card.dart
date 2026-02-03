import 'package:flutter/material.dart';

import '../../../../app/theme/app_color_scheme.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';

import '../data/models/university_model.dart';

class UniversityCard extends StatelessWidget {
  final UniversityModel university;
  final VoidCallback onTap;

  const UniversityCard({
    super.key,
    required this.university,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.card),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColorScheme.border),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            // logo
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColorScheme.surfaceMuted,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColorScheme.border),
              ),
              clipBehavior: Clip.antiAlias,
              child:
                  (university.logo_path != null &&
                      university.logo_path!.isNotEmpty)
                  ? Image.asset(university.logo_path!, fit: BoxFit.cover)
                  : const Icon(
                      AppIcons.university,
                      color: AppColorScheme.brandPrimary,
                      size: 32,
                    ),
            ),
            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    university.name,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    university.description ?? '—',
                    style: AppTextStyles.bodyMuted,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.sm),
            const Icon(
              AppIcons.chevronleft,
              color: AppColorScheme.textDisabled,
            ),
          ],
        ),
      ),
    );
  }
}
