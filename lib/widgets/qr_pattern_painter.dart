import 'dart:math';

import 'package:flutter/material.dart';

/// Purely decorative QR-look-alike module grid, deterministically generated
/// from [seed] — not a real scannable code, just a visual prop for the
/// digital membership card.
class QrPattern extends StatelessWidget {
  final double size;
  final String seed;

  const QrPattern({super.key, this.size = 72, this.seed = 'TOYOTA-TM-LOYALTY'});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: _QrPainter(seed: seed));
  }
}

class _QrPainter extends CustomPainter {
  final String seed;

  _QrPainter({required this.seed});

  static const _grid = 9;

  void _finder(Canvas canvas, Paint dark, Paint light, double x, double y, double cell) {
    canvas.drawRect(Rect.fromLTWH(x, y, cell * 3, cell * 3), dark);
    canvas.drawRect(
      Rect.fromLTWH(x + cell * 0.5, y + cell * 0.5, cell * 2, cell * 2),
      light,
    );
    canvas.drawRect(Rect.fromLTWH(x + cell, y + cell, cell, cell), dark);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / _grid;
    final dark = Paint()..color = Colors.black;
    final light = Paint()..color = Colors.white;
    final rnd = Random(seed.codeUnits.fold<int>(0, (a, b) => a * 31 + b));

    canvas.drawRect(Offset.zero & size, light);
    _finder(canvas, dark, light, 0, 0, cell);
    _finder(canvas, dark, light, size.width - cell * 3, 0, cell);
    _finder(canvas, dark, light, 0, size.height - cell * 3, cell);

    for (int row = 0; row < _grid; row++) {
      for (int col = 0; col < _grid; col++) {
        final inFinder =
            (row < 3 && col < 3) ||
            (row < 3 && col >= _grid - 3) ||
            (row >= _grid - 3 && col < 3);
        if (inFinder) continue;
        if (rnd.nextBool()) {
          canvas.drawRect(
            Rect.fromLTWH(col * cell, row * cell, cell, cell),
            dark,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QrPainter oldDelegate) => false;
}
