import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/responsive.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final tablet = context.isTablet;
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: tablet
              ? titleStyle?.copyWith(
                  fontSize: (titleStyle.fontSize ?? 16) * 1.2,
                )
              : titleStyle,
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: TextStyle(
                color: AppColors.toyotaRed,
                fontWeight: FontWeight.w600,
                fontSize: tablet ? 15 : 13,
              ),
            ),
          ),
      ],
    );
  }
}
