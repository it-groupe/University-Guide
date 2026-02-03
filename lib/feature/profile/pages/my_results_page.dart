import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_color_scheme.dart';
import '../../../app/theme/app_icons.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/widgets/app_scaffold.dart';
import '../../test/logic/tests_controller.dart';
import '../../test/pages/test_results_page.dart';

class MyResultsPage extends StatefulWidget {
  const MyResultsPage({super.key});

  @override
  State<MyResultsPage> createState() => _MyResultsPageState();
}

class _MyResultsPageState extends State<MyResultsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TestsController>().loadCompletedAttempts();
    });
  }

  String _fmt(String? sqliteTs) {
    if (sqliteTs == null) return '-';
    // SQLite: 'YYYY-MM-DD HH:MM:SS' -> DateTime.parse يحتاج T
    final normalized = sqliteTs.replaceFirst(' ', 'T');
    final dt = DateTime.tryParse(normalized);
    if (dt == null) return sqliteTs;

    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$y/$m/$d  $hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<TestsController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AppScaffold(
        title: 'سجل نتائجي',
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            if (c.isHistoryLoading)
              const Center(child: CircularProgressIndicator())
            else if (c.historyError != null)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColorScheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('حدث خطأ', style: AppTextStyles.h2),
                    const SizedBox(height: AppSpacing.sm),
                    Text(c.historyError!, style: AppTextStyles.bodyMuted),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            context.read<TestsController>().loadCompletedAttempts(),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ),
                  ],
                ),
              )
            else if (c.completed_attempts.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColorScheme.border),
                ),
                child: Text(
                  'لا توجد نتائج محفوظة بعد.',
                  style: AppTextStyles.bodyMuted,
                ),
              )
            else
              ...c.completed_attempts.map((a) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TestResultsPage(attemptId: a.attempt_id),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: AppColorScheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColorScheme.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            AppIcons.exam,
                            color: AppColorScheme.brandPrimary,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'نتيجة اختبار #${a.attempt_id}',
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'الوقت: ${_fmt(a.completed_at)}',
                                  style: AppTextStyles.bodyMuted,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            AppIcons.chevronleft,
                            color: AppColorScheme.textDisabled,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
