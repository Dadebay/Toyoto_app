import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'package:hugeicons/hugeicons.dart';

class HealthScoreRing extends StatelessWidget {
  final int score;
  final double size;
  final List<List<dynamic>>? icon;
  final String? label;
  final Color? textColor;
  final Color? trackColor;

  const HealthScoreRing({
    super.key,
    required this.score,
    this.size = 64,
    this.icon,
    this.label,
    this.textColor,
    this.trackColor,
  });

  Color get _color {
    if (score >= 90) return AppColors.success;
    if (score >= 75) return AppColors.warning;
    return AppColors.toyotaRed;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: size * 0.09,
                  backgroundColor: trackColor ?? AppColors.divider,
                  valueColor: AlwaysStoppedAnimation<Color>(_color),
                  strokeCap: StrokeCap.round,
                ),
              ),
              if (icon != null)
                HugeIcon(icon: icon!, color: _color, size: size * 0.32)
              else
                Text(
                  '$score',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: size * 0.28,
                    color: textColor ?? AppColors.textPrimary,
                  ),
                ),
            ],
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 8),
          Text(
            label!,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$score%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: _color,
            ),
          ),
        ],
      ],
    );
  }
}
