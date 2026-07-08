import 'package:flutter/material.dart';

/// Lightweight stylized "map" background (no external map SDK / API key
/// needed) so the location screens render instantly and offline.
class FakeMapBackground extends StatelessWidget {
  final Widget? child;

  const FakeMapBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE9ECEF),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _MapPainter()),
          ?child,
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFD3D8DC)
      ..strokeWidth = 10;
    final mainRoadPaint = Paint()
      ..color = const Color(0xFFC7CDD3)
      ..strokeWidth = 18;
    final blockPaint = Paint()..color = const Color(0xFFF3F5F7);

    for (double x = 0; x < size.width; x += 70) {
      canvas.drawRect(Rect.fromLTWH(x + 12, 0, 46, size.height), blockPaint);
    }

    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.32),
      mainRoadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.62),
      Offset(size.width, size.height * 0.6),
      roadPaint,
    );
    for (double x = 60; x < size.width; x += 90) {
      canvas.drawLine(Offset(x, 0), Offset(x - 20, size.height), roadPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
