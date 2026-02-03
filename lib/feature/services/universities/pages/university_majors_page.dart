import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../logic/universities_controller.dart';
import '../widgets/uni_major_card.dart';

class UniversityMajorsPage extends StatelessWidget {
  final int university_id;

  const UniversityMajorsPage({super.key, required this.university_id});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<UniversitiesController>();

    if (!c.isLoadingDetails && c.programs.isEmpty && c.detailsError == null) {
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

    if (c.programs.isEmpty) {
      return Center(
        child: Text('لا توجد تخصصات', style: AppTextStyles.bodyMuted),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: c.programs.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, i) {
        final p = c.programs[i];
        return UniMajorCard(
          program: p,
          onTap: () {
            // لاحقًا: UniversityMajorDetailsPage(program_id: p.program_id)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تفاصيل تخصص: ${p.name} (لاحقًا)')),
            );
          },
        );
      },
    );
  }
}
