import 'package:flutter/material.dart';
import 'package:flutter_application_9/app/theme/app_color_scheme.dart';
import 'package:flutter_application_9/app/theme/app_icons.dart';
import 'package:flutter_application_9/app/theme/widgets/app_scaffold.dart';
import 'package:flutter_application_9/feature/test/logic/tests_controller.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../widgets/likert_selector.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<TestsController>();

    return AppScaffold(
      title: 'اختبار',
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(AppIcons.back),
      ),

      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Builder(
          builder: (_) {
            if (c.isLoading && !c.hasQuestion) {
              return const Center(child: CircularProgressIndicator());
            }

            if (c.error != null && !c.hasQuestion) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('حدث خطأ', style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.sm),
                  Text(c.error!, style: AppTextStyles.bodyMuted),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.read<TestsController>().retry(),
                      child: const Text('محاولة مرة أخرى'),
                    ),
                  ),
                ],
              );
            }
            if (!c.hasQuestion) {
              return Center(
                child: ElevatedButton(
                  onPressed: () => context.read<TestsController>().start(),
                  child: const Text('ابدأ تحميل الأسئلة'),
                ),
              );
            }

            final q = c.question!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('سؤال', style: AppTextStyles.h2),
                const SizedBox(height: AppSpacing.md),
                Text(q.text, style: AppTextStyles.body),
                const SizedBox(height: AppSpacing.lg),

                if (q.isLikert)
                  LikertSelector(
                    value: c.selctedLikretValue,
                    points: c.likretPoints,
                    onChanged: (v) =>
                        context.read<TestsController>().selectLikret(v),
                  )
                else if (q.isSingleChoice)
                  Column(
                    children: c.choices.map((ch) {
                      final selected = c.selectedChoiceId == ch.id;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => context
                              .read<TestsController>()
                              .selectChoice(ch.id),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColorScheme.brandPrimary.withValues(
                                      alpha: 0.08,
                                    )
                                  : AppColorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected
                                    ? AppColorScheme.brandPrimary
                                    : AppColorScheme.border,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    ch.text,
                                    style: AppTextStyles.body,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  selected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: selected
                                      ? AppColorScheme.brandPrimary
                                      : AppColorScheme.textDisabled,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                else
                  Text(
                    'نوع السؤال غير مدعوم بعد (${q.type}).',
                    style: AppTextStyles.bodyMuted,
                  ),

                if (c.error != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(c.error!, style: AppTextStyles.bodyMuted),
                ],

                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        (q.isLikert && c.selctedLikretValue == null) ||
                            (q.isSingleChoice && c.selectedChoiceId == null)
                        ? null
                        : () => context.read<TestsController>().next(),
                    child: c.isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('التالي'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
