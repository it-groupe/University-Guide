import 'package:flutter/material.dart';
import 'package:flutter_application_9/app/theme/widgets/app_scaffold.dart';

import '../../../../app/theme/app_color_scheme.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/widgets/soft_background_bubbles.dart';

import '../data/models/university_model.dart';
import 'university_colleges_page.dart';
import 'university_majors_page.dart';

class UniversityDetailsPage extends StatelessWidget {
  final UniversityModel university;

  const UniversityDetailsPage({super.key, required this.university});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: AppScaffold(
        title: 'تفاصيل الجامعة',
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(AppIcons.back, color: AppColorScheme.textPrimary),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            children: [
              const Positioned.fill(child: SoftBackgroundBubbles()),
              Positioned.fill(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.md,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColorScheme.surface,
                          borderRadius: BorderRadius.circular(AppRadius.hero),
                          border: Border.all(color: AppColorScheme.border),
                          boxShadow: AppShadows.card,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            Container(
                              height: 160,
                              width: double.infinity,
                              color: AppColorScheme.surfaceMuted,
                              child:
                                  (university.logo_path != null &&
                                      university.logo_path!.isNotEmpty)
                                  ? Image.asset(
                                      university.logo_path!,
                                      fit: BoxFit.cover,
                                    )
                                  : const Center(
                                      child: Icon(
                                        AppIcons.university,
                                        size: 64,
                                        color: AppColorScheme.brandPrimary,
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    university.name,
                                    style: AppTextStyles.h2,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    university.description ?? '—',
                                    style: AppTextStyles.bodyMuted,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Tabs
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColorScheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColorScheme.border),
                        ),
                        child: const TabBar(
                          indicatorColor: AppColorScheme.brandPrimary,
                          labelColor: AppColorScheme.brandPrimary,
                          unselectedLabelColor: AppColorScheme.textSecondary,
                          tabs: [
                            Tab(text: 'الكليات'),
                            Tab(text: 'التخصصات'),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    Expanded(
                      child: TabBarView(
                        children: [
                          UniversityCollegesPage(
                            university_id: university.university_id,
                          ),
                          UniversityMajorsPage(
                            university_id: university.university_id,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
