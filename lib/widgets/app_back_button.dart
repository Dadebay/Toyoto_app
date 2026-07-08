import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../theme/app_theme.dart';

/// Consistent HugeIcons-based back button for every AppBar.
///
/// A bare [HugeIcon] placed directly in [AppBar.leading] renders at its own
/// size but still sits inside the AppBar's fixed 56x56 leading slot with no
/// proper tap target/ripple — wrapping it in [IconButton] gives it the
/// standard Material hit area and behavior other back buttons have.
class AppBackButton extends StatelessWidget {
  final Color? color;

  const AppBackButton({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: HugeIcon(
        icon: HugeIcons.strokeRoundedCircleArrowLeft01,
        color: color ?? AppColors.textPrimary,
        size: 22,
      ),
    );
  }
}
