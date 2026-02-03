import 'package:flutter/material.dart';

import '../../../../app/theme/app_color_scheme.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';

import '../data/models/program_model.dart';

class UniMajorCard extends StatelessWidget {
  final ProgramModel program;
  final VoidCallback onTap;

  const UniMajorCard({super.key, required this.program, required this.onTap});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              program.name,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              '${program.degree}${program.duration_years != null ? ' • ${program.duration_years} سنوات' : ''}',
              style: AppTextStyles.bodyMuted,
            ),
            const SizedBox(height: 6),
            Text(
              program.description ?? '—',
              style: AppTextStyles.bodyMuted,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
