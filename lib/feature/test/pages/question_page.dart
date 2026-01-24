import 'package:flutter/material.dart';
import 'package:flutter_application_9/app/theme/app_icons.dart';
import 'package:flutter_application_9/app/theme/widgets/app_scaffold.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../widgets/likert_selector.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int? selected;

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
            Text('سؤال (تجريبي)', style: AppTextStyles.h2),
            const SizedBox(height: AppSpacing.md),
            Text(
              'أستمتع بحل المشكلات خطوة بخطوة حتى لو استغرق الأمر وقتًا.',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: AppSpacing.lg),

            LikertSelector(
              value: selected,
              onChanged: (v) => setState(() => selected = v),
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selected == null ? null : () {},
                child: const Text('التالي'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
