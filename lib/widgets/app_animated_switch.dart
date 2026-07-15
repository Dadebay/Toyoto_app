import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../theme/app_theme.dart';

/// A pill-shaped switch with a sliding, bouncy thumb and a cross-fading
/// checkmark, used in place of the plain Material [Switch] for a more
/// premium feel in Settings.
class AppAnimatedSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  /// Uniformly scales the switch. Used to give it a bigger, more
  /// thumb-friendly footprint on iPad without changing the phone size.
  final double scale;

  const AppAnimatedSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.scale = 1.0,
  });

  @override
  State<AppAnimatedSwitch> createState() => _AppAnimatedSwitchState();
}

class _AppAnimatedSwitchState extends State<AppAnimatedSwitch> {
  bool _pressed = false;

  void _setPressed(bool pressed) {
    if (_pressed != pressed) setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    final on = widget.value;
    final scale = widget.scale;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => widget.onChanged(!on),
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: 50 * scale,
        height: 30 * scale,
        padding: EdgeInsets.all(3 * scale),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: on ? AppColors.bmwBlue : AppColors.divider,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          alignment: on ? Alignment.centerRight : Alignment.centerLeft,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 120),
            scale: _pressed ? 0.85 : 1.0,
            child: Container(
              width: 24 * scale,
              height: 24 * scale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: on
                    ? HugeIcon(
                        key: const ValueKey('on'),
                        icon: HugeIcons.strokeRoundedTick01,
                        color: AppColors.bmwBlue,
                        size: 13 * scale,
                      )
                    : const SizedBox.shrink(key: ValueKey('off')),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
