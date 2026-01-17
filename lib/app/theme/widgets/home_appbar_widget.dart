import 'package:flutter/material.dart';
import '../app_color_scheme.dart';
import '../app_icons.dart';
import '../app_text_styles.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onMenuTap;
  final VoidCallback onNotificationsTap;
  final bool showNotificationDot;

  const HomeAppBar({
    super.key,
    required this.title,
    required this.onMenuTap,
    required this.onNotificationsTap,
    this.showNotificationDot = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColorScheme.surface,
      centerTitle: true,
      title: Text(title, style: AppTextStyles.h1),
      leading: IconButton(
        onPressed: onMenuTap,
        icon: const Icon(AppIcons.menu, color: AppColorScheme.textPrimary),
      ),
      actions: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: onNotificationsTap,
              icon: const Icon(
                AppIcons.notifications,
                color: AppColorScheme.textPrimary,
              ),
            ),
            if (showNotificationDot)
              PositionedDirectional(
                top: 10,
                end: 10,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColorScheme.danger,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColorScheme.border),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
