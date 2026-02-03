import 'package:flutter/material.dart';
import 'package:flutter_application_9/app/theme/widgets/soft_background_bubbles.dart';
import 'package:flutter_application_9/feature/test/logic/tests_controller.dart';
import 'package:flutter_application_9/feature/test/pages/test_results_page.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_color_scheme.dart';
import '../../../app/theme/app_icons.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../logic/profile_controller.dart';
import 'edit_profile_page.dart';
import 'my_results_page.dart';
import 'settings_page.dart';

class ProfileHomePage extends StatelessWidget {
  const ProfileHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ProfileController>();

    if (c.isLoading && !c.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    if (c.error != null && !c.hasData) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
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
        ),
      );
    }

    if (!c.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    final p = c.profile!;

    return SizedBox.expand(
      child: Stack(
        children: [
          const Positioned.fill(child: SoftBackgroundBubbles()),

          Positioned.fill(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                // ===== Header Card =====
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColorScheme.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.full_name, style: AppTextStyles.h2),
                            const SizedBox(height: 4),
                            Text(p.school, style: AppTextStyles.bodyMuted),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppColorScheme.surfaceMuted,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColorScheme.border),
                        ),
                        child: const Center(
                          child: Icon(
                            AppIcons.student,
                            color: AppColorScheme.brandPrimary,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // ===== Test results card =====
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColorScheme.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'نساعدك تختار تخصصك!',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),

                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 140,
                          minWidth: 120,
                          minHeight: 40,
                          maxHeight: 40,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(
                              0,
                              40,
                            ), // يكسر minimumSize القادم من الـ Theme
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          onPressed: () async {
                            final testCtrl = context.read<TestsController>();

                            final messenger = ScaffoldMessenger.of(context);
                            final nav = Navigator.of(context);

                            final id = await testCtrl
                                .loadLastCompletedAttemptId();

                            if (id == null) {
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text('لا توجد نتائج محفوظة بعد'),
                                ),
                              );
                              return;
                            }

                            nav.push(
                              MaterialPageRoute(
                                builder: (_) => TestResultsPage(attemptId: id),
                              ),
                            );
                          },

                          child: const Text('عرض النتائج'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // ===== Menu list =====
                _MenuTile(
                  icon: AppIcons.edit,
                  title: 'تعديل الملف',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const EditProfilePage(),
                      ),
                    );
                  },
                ),
                _MenuTile(
                  icon: AppIcons.schedule,
                  title: 'سجل نتائجي',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MyResultsPage()),
                    );
                  },
                ),
                _MenuTile(
                  icon: AppIcons.favorite,
                  title: 'المفضلة',
                  onTap: () {},
                ),
                _MenuTile(
                  icon: AppIcons.subjects,
                  title: 'كورساتي',
                  onTap: () {},
                ),
                _MenuTile(
                  icon: AppIcons.settings,
                  title: 'الإعدادات',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                  },
                ),

                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
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
              Icon(icon, color: AppColorScheme.textPrimary),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(title, style: AppTextStyles.body)),
              Icon(AppIcons.chevronleft, color: AppColorScheme.textDisabled),
            ],
          ),
        ),
      ),
    );
  }
}
