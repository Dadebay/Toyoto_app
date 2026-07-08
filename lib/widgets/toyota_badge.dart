import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Custom-drawn red circular "TM" badge, echoing the reference infographic's
/// own stylized mark rather than reproducing Toyota's registered oval logo.
class ToyotaBadge extends StatelessWidget {
  final double size;

  const ToyotaBadge({super.key, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.toyotaRed,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.toyotaRed.withValues(alpha: 0.35),
            blurRadius: size * 0.3,
            offset: Offset(0, size * 0.08),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        'TM',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: size * 0.36,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
