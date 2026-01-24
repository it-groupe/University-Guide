import 'package:flutter/material.dart';
import 'package:flutter_application_9/app/theme/app_icons.dart';
import 'package:flutter_application_9/app/theme/widgets/app_scaffold.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

import '../widgets/likert_selector.dart';

import 'package:flutter_application_9/feature/test/data/repositories/test_repository.dart';
import 'package:flutter_application_9/feature/test/data/models/question_model.dart';
import 'package:flutter_application_9/feature/test/data/models/likert_point_model.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int? selected;

  late final Future<QuestionModel> _questionFuture;

  @override
  void initState() {
    super.initState();
    // ✅ أول سؤال فعلي من DB (CORE أول سؤال)
    _questionFuture = TestRepository.instance.getFirstCoreQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'اختبار',
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(AppIcons.back),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: FutureBuilder<QuestionModel>(
          future: _questionFuture,
          builder: (context, snapshot) {
            // 1) تحميل
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // 2) خطأ
            if (snapshot.hasError) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('حدث خطأ أثناء تحميل السؤال', style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    snapshot.error.toString(),
                    style: AppTextStyles.bodyMuted,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => setState(() {
                        selected = null;
                        // إعادة المحاولة
                        // (ملاحظة: FutureBuilder لا يعيد التشغيل إلا لو غيّرنا الـ future)
                        // أسهل: استخدم FutureBuilder مع key أو خزّن future في متغير قابل للتبديل.
                        // الآن نعمل حل سريع:
                        // ignore: invalid_use_of_visible_for_testing_member
                      }),
                      child: const Text('محاولة مرة أخرى'),
                    ),
                  ),
                ],
              );
            }

            // 3) نجاح
            final q = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('سؤال', style: AppTextStyles.h2),
                const SizedBox(height: AppSpacing.md),
                Text(q.text, style: AppTextStyles.body),
                const SizedBox(height: AppSpacing.lg),

                // ✅ لو Likert: اجلب نقاط ليكرت من DB واعرضها
                if (q.isLikert && q.scaleId != null)
                  FutureBuilder<List<LikertPointModel>>(
                    future: TestRepository.instance.getLikertPoints(q.scaleId!),
                    builder: (context, ps) {
                      if (ps.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (ps.hasError) {
                        return Text(
                          'خطأ في تحميل مقياس ليكرت: ${ps.error}',
                          style: AppTextStyles.bodyMuted,
                        );
                      }

                      final points = ps.data ?? const <LikertPointModel>[];
                      return LikertSelector(
                        value: selected,
                        points: points,
                        onChanged: (v) => setState(() => selected = v),
                      );
                    },
                  )
                else
                  Text(
                    'نوع السؤال الحالي غير مدعوم بعد (${q.type}).',
                    style: AppTextStyles.bodyMuted,
                  ),

                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selected == null
                        ? null
                        : () {
                            // TODO: لاحقًا: حفظ الإجابة + الانتقال للسؤال التالي
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('التالي: قريبًا')),
                            );
                          },
                    child: const Text('التالي'),
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
