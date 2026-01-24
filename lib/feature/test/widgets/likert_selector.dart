import 'package:flutter/material.dart';
import '../../../app/theme/app_color_scheme.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../test/data/models/likert_point_model.dart';

class LikertSelector extends StatelessWidget {
  final int? value; // 1..5
  final ValueChanged<int> onChanged;
  final List<LikertPointModel> points; // من DB

  const LikertSelector({
    super.key,
    required this.value,
    required this.onChanged,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    // احتياط: لو DB رجع نقاط فارغة لأي سبب
    if (points.isEmpty) {
      return Text('لا توجد نقاط مقياس ليكرت.', style: AppTextStyles.bodyMuted);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('اختر درجة الموافقة:', style: AppTextStyles.label),
        const SizedBox(height: AppSpacing.sm),

        // أزرار 1..5
        Row(
          children: List.generate(points.length, (i) {
            final p = points[i];
            final v = p.value;
            final selected = value == v;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onChanged(v),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColorScheme.brandPrimary.withValues(alpha: 0.12)
                          : AppColorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? AppColorScheme.brandPrimary
                            : AppColorScheme.border,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        v.toString(),
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? AppColorScheme.brandPrimary
                              : AppColorScheme.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: AppSpacing.md),

        // وصف النقطة المختارة (عربي) من DB
        if (value != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColorScheme.border),
            ),
            child: Text(
              points.firstWhere((p) => p.value == value!).label,
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
