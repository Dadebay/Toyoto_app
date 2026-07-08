import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import 'package:hugeicons/hugeicons.dart';

class QuickAction {
  final List<List<dynamic>> icon;
  final String label;
  final VoidCallback onTap;

  const QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class QuickActionGrid extends StatelessWidget {
  final List<QuickAction> actions;

  /// Overrides the column count on both phone and tablet. Leave null to use
  /// the built-in phone (4) / iPad (6) defaults.
  final int? crossAxisCount;

  const QuickActionGrid({super.key, required this.actions, this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    final tablet = context.isTablet;
    final columns = crossAxisCount ?? (tablet ? 6 : 4);
    final iconBoxSize = tablet ? 68.0 : 52.0;
    final iconSize = tablet ? 30.0 : 22.0;
    final fontSize = tablet ? 13.5 : 11.5;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: tablet ? 20 : 14,
        crossAxisSpacing: tablet ? 18 : 12,
        childAspectRatio: tablet ? 0.95 : 0.82,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        return GestureDetector(
          onTap: action.onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: iconBoxSize,
                height: iconBoxSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(tablet ? 20 : 16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: HugeIcon(
                  icon: action.icon,
                  color: AppColors.toyotaRed,
                  size: iconSize,
                ),
              ),
              SizedBox(height: tablet ? 10 : 8),
              Text(
                action.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.15,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
