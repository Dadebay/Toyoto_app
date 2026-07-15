import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Two-segment donut chart showing principal vs. total interest, drawn with
/// [CustomPainter] since [HealthScoreRing] only supports a single 0-100
/// percentage value.
class FinanceRingChart extends StatelessWidget {
  final double principal;
  final double interest;
  final double size;

  const FinanceRingChart({
    super.key,
    required this.principal,
    required this.interest,
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    final total = principal + interest;
    final principalFraction = total <= 0 ? 0.0 : principal / total;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _FinanceRingPainter(principalFraction: principalFraction),
        child: Center(
          child: Text(
            '${(principalFraction * 100).round()}%',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: size * 0.2,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _FinanceRingPainter extends CustomPainter {
  final double principalFraction;

  _FinanceRingPainter({required this.principalFraction});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.12;
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    final trackPaint = Paint()
      ..color = AppColors.divider
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(rect, 0, 2 * pi, false, trackPaint);

    final principalPaint = Paint()
      ..color = AppColors.bmwBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, -pi / 2, 2 * pi * principalFraction, false, principalPaint);

    final interestPaint = Paint()
      ..color = AppColors.warning
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect,
      -pi / 2 + 2 * pi * principalFraction,
      2 * pi * (1 - principalFraction),
      false,
      interestPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _FinanceRingPainter oldDelegate) =>
      oldDelegate.principalFraction != principalFraction;
}
