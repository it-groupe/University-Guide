import 'package:flutter/material.dart';
import 'package:flutter_application_9/app/theme/app_icons.dart';
import 'package:flutter_application_9/app/theme/widgets/app_scaffold.dart';
import 'package:flutter_application_9/feature/test/logic/tests_controller.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

import 'question_page.dart';

class TestInstructionsPage extends StatelessWidget {
  const TestInstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'اختبار',
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        //
        icon: Icon(AppIcons.back),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تعليمات قبل البدء', style: AppTextStyles.h2),
            const SizedBox(height: AppSpacing.md),
            const Text(
              '• خذ وقتك في الإجابة.\n• لا توجد إجابة صحيحة أو خاطئة.\n• أجب بصدق لتحصل على نتيجة أدق.',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final c = context.read<TestsController>();
                  c.retry();
                  c.start();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const QuestionPage()),
                  );
                },

                child: const Text('متابعة'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
