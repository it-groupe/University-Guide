import 'package:flutter/material.dart';
import 'package:flutter_application_9/app/theme/app_color_scheme.dart';
import 'package:flutter_application_9/app/theme/widgets/app_scaffold.dart';
import 'package:flutter_application_9/app/theme/app_spacing.dart';
import 'package:flutter_application_9/app/theme/app_text_styles.dart';
import 'package:flutter_application_9/feature/test/logic/tests_controller.dart';
import 'package:provider/provider.dart';

class TestResultsPage extends StatelessWidget {
  final int? attemptId; //  عشان لو فتحنا من الرئيسية
  const TestResultsPage({super.key, this.attemptId});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<TestsController>();

    return AppScaffold(
      title: 'نتيجة الاختبار',
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final id = attemptId ?? c.attemptId;
              final alreadyLoaded =
                  c.topMajors.isNotEmpty || c.resultsError != null;
              if (!alreadyLoaded && id != null && !c.isResultsLoading) {
                c.loadResults(attemptId: id);
              }
            });

            if (c.isResultsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (c.resultsError != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('حدث خطأ', style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.sm),
                  Text(c.resultsError!, style: AppTextStyles.bodyMuted),
                ],
              );
            }

            final rows = c.topMajors;
            if (rows.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('لا توجد نتائج', style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.sm),
                  Text('لم نجد نتائج محفوظة.', style: AppTextStyles.bodyMuted),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 3,
                          offset: Offset(1, 1),
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Text('أفضل 5 تخصصات', style: AppTextStyles.h2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                for (final r in rows)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColorScheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(width: 0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 3,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text('#${r.rank}', style: AppTextStyles.h2),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.name, style: AppTextStyles.body),
                                if ((r.college ?? '').isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      r.college!,
                                      style: AppTextStyles.bodyMuted,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Text(
                            r.score.toStringAsFixed(2),
                            style: AppTextStyles.body,
                          ),
                        ],
                      ),
                    ),
                  ),

                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('رجوع'),
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
