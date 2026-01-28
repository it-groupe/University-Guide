import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

import 'test_instructions_page.dart';

class TestLandingPage extends StatelessWidget {
  const TestLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('اختبار تحديد الميول', style: AppTextStyles.h2),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'جاوب على الأسئلة لنقترح لك التخصص الأقرب لميولك.',
              style: AppTextStyles.bodyMuted,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TestInstructionsPage(),
                    ),
                  );
                },
                child: const Text('ابدأ الاختبار'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
