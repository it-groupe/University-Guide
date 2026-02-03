import 'package:flutter/material.dart';
import 'package:flutter_application_9/app/theme/widgets/app_scaffold.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/widgets/soft_background_bubbles.dart';

import '../logic/universities_controller.dart';
import '../widgets/university_card.dart';
import 'university_details_page.dart';

class UniversitiesListPage extends StatelessWidget {
  const UniversitiesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<UniversitiesController>();

    if (!c.isLoading && c.universities.isEmpty && c.error == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => c.load());
    }

    return AppScaffold(
      title: 'الجامعات',
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            const Positioned.fill(child: SoftBackgroundBubbles()),
            Positioned.fill(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  TextField(
                    onChanged: c.setQuery,
                    decoration: const InputDecoration(
                      hintText: 'ابحث عن جامعة...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  if (c.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (c.error != null)
                    Text(c.error!, style: AppTextStyles.bodyMuted)
                  else if (c.filtered.isEmpty)
                    Text('لا توجد جامعات', style: AppTextStyles.bodyMuted)
                  else
                    ...c.filtered.map(
                      (u) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: UniversityCard(
                          university: u,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    UniversityDetailsPage(university: u),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
