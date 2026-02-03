import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_color_scheme.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/widgets/soft_background_bubbles.dart';

import '../logic/courses_controller.dart';
import '../widgets/course_card.dart';

class CoursesCatalogPage extends StatelessWidget {
  const CoursesCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CoursesController>();

    if (!c.isLoading && c.courses.isEmpty && c.error == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => c.load());
    }

    return Scaffold(
      backgroundColor: AppColorScheme.mainbackgroun,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            const Positioned.fill(child: SoftBackgroundBubbles()),

            Positioned.fill(
              child: SafeArea(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    TextField(
                      onChanged: c.setQuery,
                      decoration: const InputDecoration(
                        hintText: 'ابحث عن كورس...',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // فلتر بسيط حسب program
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'الكل',
                            selected: c.program_id_filter == null,
                            onTap: () => c.setProgramFilter(null),
                          ),
                          const SizedBox(width: 10),
                          ...c.programs.map(
                            (p) => Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: _FilterChip(
                                label: p.name,
                                selected: c.program_id_filter == p.program_id,
                                onTap: () => c.setProgramFilter(p.program_id),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    if (c.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (c.error != null)
                      Text(c.error!, style: AppTextStyles.bodyMuted)
                    else if (c.filtered.isEmpty)
                      Text(
                        'لا يوجد كورسات مطابقة',
                        style: AppTextStyles.bodyMuted,
                      )
                    else
                      ...c.filtered.map(
                        (course) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: CourseCard(
                            course: course,
                            onTap: () {
                              // لاحقًا: CourseDetailsPage(course_id: course.course_id)
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColorScheme.brandPrimary.withValues(alpha: 0.12)
              : AppColorScheme.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppColorScheme.brandPrimary
                : AppColorScheme.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w700,
            color: selected
                ? AppColorScheme.brandPrimary
                : AppColorScheme.textPrimary,
          ),
        ),
      ),
    );
  }
}
