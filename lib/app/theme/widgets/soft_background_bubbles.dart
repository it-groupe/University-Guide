import 'package:flutter/material.dart';
import '../app_color_scheme.dart';

class SoftBackgroundBubbles extends StatelessWidget {
  const SoftBackgroundBubbles({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _BubblesPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _BubblesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Paint()
      ..color = AppColorScheme.surfaceMuted.withValues(alpha: 0.55);

    final p2 = Paint()
      ..color = AppColorScheme.brandPrimary.withValues(alpha: 0.06);

    final p3 = Paint()
      ..color = AppColorScheme.brandSecondary.withValues(alpha: 0.06);

    void circle(double x, double y, double r, Paint p) {
      canvas.drawCircle(Offset(size.width * x, size.height * y), r, p);
    }

    circle(0.10, 0.12, 70, p1);
    circle(0.85, 0.18, 90, p2);
    circle(0.18, 0.58, 110, p3);
    circle(0.95, 0.72, 80, p1);
    circle(0.55, 0.96, 120, p2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
