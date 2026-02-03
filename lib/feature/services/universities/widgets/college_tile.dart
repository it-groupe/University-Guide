import 'package:flutter/material.dart';

import '../../../../app/theme/app_color_scheme.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';

import '../data/models/college_model.dart';

class CollegeTile extends StatelessWidget {
  final CollegeModel college;
  final VoidCallback onTap;

  const CollegeTile({super.key, required this.college, required this.onTap});

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
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColorScheme.surfaceMuted,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColorScheme.border),
              ),
              clipBehavior: Clip.antiAlias,
              child:
                  (college.image_path != null && college.image_path!.isNotEmpty)
                  ? Image.asset(college.image_path!, fit: BoxFit.cover)
                  : const Center(
                      child: Icon(
                        AppIcons.college,
                        color: AppColorScheme.brandPrimary,
                        size: 26,
                      ),
                    ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    college.name,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    college.description ?? '—',
                    style: AppTextStyles.bodyMuted,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
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
