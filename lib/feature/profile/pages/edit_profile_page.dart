import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_color_scheme.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/widgets/app_scaffold.dart';
import '../logic/profile_controller.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _schoolCtrl;

  @override
  void initState() {
    super.initState();
    final c = context.read<ProfileController>();
    final p = c.profile;

    _fullNameCtrl = TextEditingController(text: p?.full_name ?? '');
    _schoolCtrl = TextEditingController(text: p?.school ?? '');
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _schoolCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ProfileController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AppScaffold(
        title: 'تعديل الملف',
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColorScheme.border),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('بياناتك الأساسية', style: AppTextStyles.h2),
                    const SizedBox(height: AppSpacing.lg),

                    Text('الاسم', style: AppTextStyles.label),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _fullNameCtrl,
                      decoration: const InputDecoration(
                        hintText: 'اكتب اسمك',
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'الاسم مطلوب';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    Text('المدرسة', style: AppTextStyles.label),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _schoolCtrl,
                      decoration: const InputDecoration(
                        hintText: 'اكتب اسم المدرسة',
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'اسم المدرسة مطلوب';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: c.isUpdating
                            ? null
                            : () async {
                                if (!(_formKey.currentState?.validate() ??
                                    false)) {
                                  return;
                                }

                                final messenger =
                                    ScaffoldMessenger.of(context);
                                final nav = Navigator.of(context);

                                try {
                                  await context
                                      .read<ProfileController>()
                                      .update_profile(
                                        full_name: _fullNameCtrl.text.trim(),
                                        school: _schoolCtrl.text.trim(),
                                      );

                                  if (!context.mounted) return;

                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text('تم حفظ التعديلات'),
                                    ),
                                  );

                                  nav.pop();
                                } catch (_) {
                                  if (!context.mounted) return;
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        c.updateError ?? 'حدث خطأ أثناء الحفظ',
                                      ),
                                    ),
                                  );
                                }
                              },
                        child: c.isUpdating
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('حفظ'),
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
