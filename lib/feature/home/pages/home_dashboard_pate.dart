import 'package:flutter/material.dart';
import 'package:flutter_application_9/feature/services/cources/pages/courses_catalog_page.dart';
import 'package:flutter_application_9/feature/services/universities/pages/universities_list_page.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_9/app/theme/app_icons.dart';
import 'package:flutter_application_9/app/theme/app_spacing.dart';
import 'package:flutter_application_9/app/theme/app_text_styles.dart';
import 'package:flutter_application_9/app/theme/widgets/soft_background_bubbles.dart';

import 'package:flutter_application_9/feature/auth/logic/auth_controller.dart';

import '../widgets/home_greeting_card.dart';
import '../widgets/home_service_card.dart';

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    final bool isGuest = auth.isGuest;

    final String greetingTitle = isGuest
        ? 'مرحباً بك يا زائر'
        : 'مرحباً يا ${auth.displayName}';

    final String greetingSubtitle = isGuest
        ? 'يمكنك التصفح كضيف، وبعض الميزات تتطلب تسجيل.'
        : 'جاهز نساعدك تختار تخصصك وتطور مهاراتك.';

    return SizedBox.expand(
      child: Stack(
        children: [
          const Positioned.fill(child: SoftBackgroundBubbles()),

          Positioned.fill(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                HomeGreetingCard(
                  title: greetingTitle,
                  subtitle: greetingSubtitle,
                ),
                const SizedBox(height: AppSpacing.lg),

                Text('الخدمات', style: AppTextStyles.h2),
                const SizedBox(height: AppSpacing.sm),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.05,
                  children: [
                    HomeServiceCard(
                      title: 'الجامعات',
                      subtitle: 'دليل الجامعات',
                      icon: AppIcons.university,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const UniversitiesListPage(),
                          ),
                        );
                      },
                    ),
                    HomeServiceCard(
                      title: 'الكورسات',
                      subtitle: 'تعلم وتدرّب',
                      icon: AppIcons.subjects,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CoursesCatalogPage(),
                          ),
                        );
                      },
                    ),
                    HomeServiceCard(
                      title: 'اختبارات القبول',
                      subtitle: 'تعلم وتدرّب',
                      icon: AppIcons.test,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
