import 'package:flutter/material.dart';
import '../../../app/theme/app_color_scheme.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class LikertSelector extends StatelessWidget {
  final int? value; // 1..5
  final ValueChanged<int> onChanged;

  const LikertSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final labels = const ['1', '2', '3', '4', '5'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('اختر درجة الموافقة:', style: AppTextStyles.label),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: List.generate(5, (i) {
            final v = i + 1;
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
                        labels[i],
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
      ],
    );
  }
}
