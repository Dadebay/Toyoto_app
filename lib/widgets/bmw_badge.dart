import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Custom-drawn dark circular "M" badge with the BMW Motorsport tricolor stripe,
/// echoing BMW's M identity rather than reproducing BMW's registered roundel.
class BmwBadge extends StatelessWidget {
  final double size;

  const BmwBadge({super.key, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.black,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.bmwBlue.withValues(alpha: 0.35),
            blurRadius: size * 0.3,
            offset: Offset(0, size * 0.08),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // BMW M tricolor stripe running diagonally behind the mark.
          Positioned(
            left: 0,
            right: 0,
            bottom: size * 0.16,
            child: Row(
              children: [
                Expanded(
                  child: Container(height: size * 0.1, color: AppColors.mLightBlue),
                ),
                Expanded(
                  child: Container(height: size * 0.1, color: AppColors.mDarkBlue),
                ),
                Expanded(
                  child: Container(height: size * 0.1, color: AppColors.mRed),
                ),
              ],
            ),
          ),
          Text(
            'M',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: size * 0.42,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
