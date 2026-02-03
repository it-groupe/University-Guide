import 'package:flutter/material.dart';
import '../../../../app/theme/app_color_scheme.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../cources/data/models/course_model.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;

  const CourseCard({super.key, required this.course, required this.onTap});

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
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppColorScheme.surfaceMuted,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColorScheme.border),
              ),
              child: const Icon(
                Icons.menu_book_outlined,
                color: AppColorScheme.brandPrimary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.name, style: AppTextStyles.h2),
                  const SizedBox(height: 4),
                  Text(
                    '${course.code ?? '—'} • ${course.credit_hours ?? 0} ساعات',
                    style: AppTextStyles.label,
                  ),
                  if ((course.description ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      course.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMuted,
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_left, color: AppColorScheme.textDisabled),
          ],
        ),
      ),
    );
  }
}
