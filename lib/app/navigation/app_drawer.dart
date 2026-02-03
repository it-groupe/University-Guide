import 'package:flutter/material.dart';

import '../theme/app_color_scheme.dart';
import '../theme/app_icons.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_gradient_scheme.dart';
import '../theme/app_radius.dart';

class AppDrawer extends StatelessWidget {
  final bool isGuest;
  final String userName;

  final VoidCallback onHomeTap;
  final VoidCallback onSearchTap;

  final VoidCallback onLoginTap;
  final VoidCallback onLogoutTap;

  const AppDrawer({
    super.key,
    required this.isGuest,
    required this.userName,
    required this.onHomeTap,
    required this.onSearchTap,
    required this.onLoginTap,
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    final headerTitle = isGuest ? 'مرحباً بك' : 'أهلاً $userName';
    final headerSub = isGuest ? 'سجّل دخولك للاستفادة' : 'اختر من القائمة';

    return Drawer(
      backgroundColor: AppColorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            // ===== Header =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: AppGradientScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  _AvatarCircle(
                    label: _firstLetter(isGuest ? 'زائر' : userName),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          headerTitle,
                          style: AppTextStyles.h2.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          headerSub,
                          style: AppTextStyles.body.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ===== Menu items =====
            _DrawerTile(
              icon: AppIcons.home,
              title: 'الرئيسية',
              onTap: () {
                Navigator.pop(context);
                onHomeTap();
              },
            ),

            _DrawerTile(
              icon: AppIcons.search,
              title: 'بحث',
              onTap: () {
                Navigator.pop(context);
                onSearchTap();
              },
            ),

            // ✅ الإعدادات "قريباً"
            _DrawerTile(
              icon: AppIcons.settings,
              title: 'الإعدادات',
              trailing: const _SoonBadge(),
              onTap: () {
                // لا شيء حالياً
              },
            ),

            _DrawerTile(icon: AppIcons.help, title: 'مساعدة', onTap: () {}),

            _DrawerTile(icon: AppIcons.info, title: 'المطورين', onTap: () {}),

            const Spacer(),

            // ===== Bottom action =====
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColorScheme.surface,
                    foregroundColor: isGuest
                        ? AppColorScheme.brandPrimary
                        : AppColorScheme.danger,
                    side: BorderSide(
                      color: isGuest
                          ? AppColorScheme.border
                          : AppColorScheme.danger.withValues(alpha: 0.35),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                  ),
                  icon: Icon(isGuest ? AppIcons.student : AppIcons.logout),
                  label: Text(isGuest ? 'تسجيل الدخول' : 'تسجيل الخروج'),
                  onPressed: () {
                    Navigator.pop(context);
                    if (isGuest) {
                      onLoginTap();
                    } else {
                      onLogoutTap();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _firstLetter(String name) {
    final t = name.trim();
    if (t.isEmpty) return '؟';
    return t.characters.first;
  }
}

class _AvatarCircle extends StatelessWidget {
  final String label;
  const _AvatarCircle({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.h2.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class _SoonBadge extends StatelessWidget {
  const _SoonBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColorScheme.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColorScheme.border),
      ),
      child: Text(
        'قريباً',
        style: AppTextStyles.label.copyWith(
          fontWeight: FontWeight.w800,
          color: AppColorScheme.textSecondary,
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColorScheme.textPrimary),
      title: Text(title, style: AppTextStyles.body),
      trailing:
          trailing ??
          Icon(AppIcons.chevronleft, color: AppColorScheme.textDisabled),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    );
  }
}
