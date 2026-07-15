import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_theme.dart';

const _kExpenseColors = [
  AppColors.toyotaRed,
  AppColors.warning,
  Color(0xFF2B7DE9),
];

/// Grouped bar chart (fuel / service / parts) for the last few months.
class MonthlyExpenseBarChart extends StatelessWidget {
  final List<MonthlyExpense> data;
  final double height;

  const MonthlyExpenseBarChart({super.key, required this.data, this.height = 160});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(painter: _BarChartPainter(data: data)),
        ),
        const SizedBox(height: 8),
        Row(
          children: data.map((e) {
            const monthNames = [
              'Ýan', 'Few', 'Mart', 'Apr', 'Maý', 'Iýun',
              'Iýul', 'Awg', 'Sen', 'Okt', 'Noý', 'Dek',
            ];
            return Expanded(
              child: Text(
                monthNames[e.month.month - 1],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<MonthlyExpense> data;

  _BarChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final maxTotal = data
        .map((e) => [e.fuelCost, e.serviceCost, e.partsCost].reduce((a, b) => a > b ? a : b))
        .reduce((a, b) => a > b ? a : b);
    if (maxTotal <= 0) return;

    final groupWidth = size.width / data.length;
    final barWidth = groupWidth * 0.18;
    const gap = 4.0;

    for (int i = 0; i < data.length; i++) {
      final e = data[i];
      final groupCenter = groupWidth * i + groupWidth / 2;
      final values = [e.fuelCost, e.serviceCost, e.partsCost];
      final totalBarsWidth = barWidth * 3 + gap * 2;
      double x = groupCenter - totalBarsWidth / 2;

      for (int j = 0; j < 3; j++) {
        final h = (values[j] / maxTotal) * (size.height - 4);
        final paint = Paint()..color = _kExpenseColors[j];
        final rect = RRect.fromRectAndCorners(
          Rect.fromLTWH(x, size.height - h, barWidth, h),
          topLeft: const Radius.circular(3),
          topRight: const Radius.circular(3),
        );
        canvas.drawRRect(rect, paint);
        x += barWidth + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) =>
      oldDelegate.data != data;
}
