import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../logic/universities_controller.dart';
import '../widgets/college_tile.dart';

class UniversityCollegesPage extends StatelessWidget {
  final int university_id;

  const UniversityCollegesPage({super.key, required this.university_id});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<UniversitiesController>();

    if (!c.isLoadingDetails && c.colleges.isEmpty && c.detailsError == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        c.loadUniversityDetails(university_id);
      });
    }

    if (c.isLoadingDetails) {
      return const Center(child: CircularProgressIndicator());
    }

    if (c.detailsError != null) {
      return Center(
        child: Text(c.detailsError!, style: AppTextStyles.bodyMuted),
      );
    }

    if (c.colleges.isEmpty) {
      return Center(
        child: Text('لا توجد كليات', style: AppTextStyles.bodyMuted),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: c.colleges.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, i) {
        final college = c.colleges[i];
        return CollegeTile(
          college: college,
          onTap: () {
            // لاحقًا: CollegeDetailsPage تعرض معلومات الكلية + تخصصاتها (حسب college_id)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'فتح: ${college.name} (لاحقًا صفحة تفاصيل الكلية)',
                ),
              ),
            );
          },
        );
      },
    );
  }
}
