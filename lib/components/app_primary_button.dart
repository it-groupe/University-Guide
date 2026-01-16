import 'package:flutter/material.dart';
import '../../design/app_color_scheme.dart';
import '../../design/app_radius.dart';
import '../../design/app_text_styles.dart';
import '../../design/app_shadows.dart';

class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double hight;
  final double width;
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.hight,
    required this.width,
    //
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: hight,
        width: width,
        decoration: BoxDecoration(
          color: AppColorScheme.brandPrimary,
          borderRadius: BorderRadius.circular(AppRadius.button),
          boxShadow: AppShadows.elevatedButton,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
