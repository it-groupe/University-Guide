import 'package:flutter/material.dart';
import 'package:flutter_application_9/app/theme/app_color_scheme.dart';
import 'package:flutter_application_9/app/theme/app_icons.dart';
import 'package:flutter_application_9/app/theme/widgets/app_scaffold.dart';
import 'package:flutter_application_9/feature/test/logic/tests_controller.dart';
import 'package:flutter_application_9/feature/test/pages/test_results_page.dart';
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
            if (c.isLoading && !c.hasQuestion && c.phase != TestPhase.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (c.error != null &&
                !c.hasQuestion &&
                c.phase != TestPhase.done) {
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
                      onPressed: () => c.retry(),
                      child: const Text('محاولة مرة أخرى'),
                    ),
                  ),
                ],
              );
            }

            if (c.phase == TestPhase.done || !c.hasQuestion) {
              if (c.isLoading) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('جارٍ إنهاء الاختبار...', style: AppTextStyles.h2),
                    const SizedBox(height: AppSpacing.md),
                    const Center(child: CircularProgressIndicator()),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('انتهى الاختبار', style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'يمكنك الآن عرض نتيجتك بالتفصيل.',
                    style: AppTextStyles.bodyMuted,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (c.attemptId == null)
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChangeNotifierProvider.value(
                                    value: c,
                                    child: TestResultsPage(
                                      attemptId: c.attemptId,
                                    ),
                                  ),
                                ),
                              );
                            },

                      child: const Text('عرض النتيجة'),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => c.retry(),
                      child: const Text('إعادة الاختبار'),
                    ),
                  ),
                ],
              );
            }

            final q = c.question!;
            final isLikert = q.isLikert;
            final isSingleChoice = q.isSingleChoice;

            Widget answerWidget;

            if (isLikert) {
              answerWidget = LikertSelector(
                value: c.selctedLikretValue,
                points: c.likretPoints,
                onChanged: (v) => c.selectLikret(v),
              );
            } else if (isSingleChoice) {
              answerWidget = Column(
                children: c.choices.map((ch) {
                  final selected = c.selectedChoiceId == ch.id;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => c.selectChoice(ch.id),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColorScheme.brandPrimary.withValues(
                                  alpha: 0.10,
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
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selected
                                      ? AppColorScheme.brandPrimary
                                      : AppColorScheme.textDisabled,
                                  width: 2,
                                ),
                              ),
                              child: selected
                                  ? Center(
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColorScheme.brandPrimary,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                ch.text,
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            } else {
              answerWidget = Text(
                'نوع السؤال غير مدعوم بعد (${q.type}).',
                style: AppTextStyles.bodyMuted,
              );
            }

            final disableNext =
                (isLikert && c.selctedLikretValue == null) ||
                (isSingleChoice && c.selectedChoiceId == null);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('سؤال', style: AppTextStyles.h2),
                const SizedBox(height: AppSpacing.md),
                Text(q.text, style: AppTextStyles.body),
                const SizedBox(height: AppSpacing.lg),

                answerWidget,

                if (c.error != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(c.error!, style: AppTextStyles.bodyMuted),
                ],

                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: disableNext ? null : () => c.next(),
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
