import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_color_scheme.dart';
import '../../../app/theme/app_icons.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme_controller.dart';
import '../../../app/theme/widgets/app_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AppScaffold(
        title: 'الإعدادات',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('المظهر', style: AppTextStyles.h2),
                  const SizedBox(height: AppSpacing.md),

                  _SwitchTile(
                    icon: AppIcons.dark_mode,
                    title: 'الوضع الداكن',
                    value: theme.is_dark,
                    onChanged: (v) =>
                        context.read<ThemeController>().set_dark(v),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  Text(
                    'ملاحظة:حاليا ماقد اضفنا ثيم .',
                    style: AppTextStyles.bodyMuted,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            _ActionTile(
              icon: AppIcons.logout,
              title: 'تسجيل الخروج',
              subtitle: 'سيتم تفعيله مع نظام تسجيل الدخول',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('قريبًا: تسجيل الخروج')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColorScheme.textPrimary),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Text(title, style: AppTextStyles.body)),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.body),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(subtitle!, style: AppTextStyles.bodyMuted),
                    ],
                  ],
                ),
              ),
              Icon(AppIcons.chevronleft, color: AppColorScheme.textDisabled),
            ],
          ),
        ),
      ),
    );
  }
}
