import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../l10n/strings.dart';
import '../services/sound_service.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import 'package:hugeicons/hugeicons.dart';

class RemoteConnectScreen extends StatelessWidget {
  const RemoteConnectScreen({super.key});

  void _toggleLock(BuildContext context, AppState appState) {
    final wasLocked = appState.locked;
    appState.toggleLock();
    SoundService.instance.play(
      wasLocked ? SoundEffect.unlock : SoundEffect.lock,
    );
    HapticFeedback.mediumImpact();
  }

  void _startEngine() {
    SoundService.instance.play(SoundEffect.engineStart);
    HapticFeedback.heavyImpact();
  }

  void _minorAction() {
    SoundService.instance.play(SoundEffect.tap, volume: .4);
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final locked = appState.locked;
    final vehicle = MockData.myVehicle;
    final tablet = context.isTablet;
    final lockButtonSize = tablet ? 180.0 : 120.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemOverlay.forDarkScreens,
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              // Kept centered rather than split into columns: the lock
              // button is a symmetric, theatrical focal control (like the
              // vehicle 3D card) that would lose impact stuffed into a
              // sidebar — but sized generously so it doesn't look like a
              // narrow phone screen floating in blank space.
              constraints: BoxConstraints(
                maxWidth: tablet ? 760 : double.infinity,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowLeft02,
                            color: Colors.white,
                            size: tablet ? 26 : 24,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            context.tr('remote_title'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: tablet ? 22 : 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: tablet ? 56 : 48),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          context.tr('connected'),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: tablet ? 15 : 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      vehicle.model,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: tablet ? 27 : 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedCar02,
                      size: tablet ? 230 : 140,
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      locked ? context.tr('locked') : context.tr('unlocked'),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: tablet ? 15 : 13,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: lockButtonSize + 100,
                      height: lockButtonSize + 100,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _PulseRings(
                            color: locked
                                ? AppColors.toyotaRed
                                : AppColors.success,
                            size: lockButtonSize,
                          ),
                          GestureDetector(
                            onTap: () => _toggleLock(context, appState),
                            child: Container(
                              width: lockButtonSize,
                              height: lockButtonSize,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: locked
                                    ? AppColors.toyotaRed
                                    : AppColors.success,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (locked
                                                ? AppColors.toyotaRed
                                                : AppColors.success)
                                            .withValues(alpha: 0.4),
                                    blurRadius: 30,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: HugeIcon(
                                icon: locked
                                    ? HugeIcons.strokeRoundedSquareLock02
                                    : HugeIcons.strokeRoundedSquareUnlock01,
                                color: Colors.white,
                                size: tablet ? 66 : 46,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      context.tr('tap_to_unlock'),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: tablet ? 14 : 12,
                      ),
                    ),
                    SizedBox(height: tablet ? 34 : 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _RemoteButton(
                          icon: HugeIcons.strokeRoundedPower,
                          label: context.tr('engine_start'),
                          onTap: _startEngine,
                          tablet: tablet,
                        ),
                        _RemoteButton(
                          icon: HugeIcons.strokeRoundedSnow,
                          label: context.tr('qa_climate'),
                          onTap: _minorAction,
                          tablet: tablet,
                        ),
                        _RemoteButton(
                          icon: HugeIcons.strokeRoundedMegaphone02,
                          label: context.tr('horn'),
                          onTap: _minorAction,
                          tablet: tablet,
                        ),
                        _RemoteButton(
                          icon: HugeIcons.strokeRoundedBulb,
                          label: context.tr('lights'),
                          onTap: _minorAction,
                          tablet: tablet,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Radar-style pulse: three rings continuously expand and fade behind the
/// lock button while this screen is visible.
class _PulseRings extends StatefulWidget {
  final Color color;
  final double size;

  const _PulseRings({required this.color, this.size = 120});

  @override
  State<_PulseRings> createState() => _PulseRingsState();
}

class _PulseRingsState extends State<_PulseRings>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Stack(
          alignment: Alignment.center,
          children: List.generate(3, (i) {
            final t = (_controller.value + i / 3) % 1.0;
            final scale = 1.0 + t * 0.85;
            final opacity = (1.0 - t).clamp(0.0, 1.0) * 0.5;
            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: widget.color, width: 2),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _RemoteButton extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String label;
  final VoidCallback onTap;
  final bool tablet;

  const _RemoteButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.tablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(tablet ? 22 : 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: HugeIcon(
              icon: icon,
              color: Colors.white,
              size: tablet ? 32 : 22,
            ),
          ),
          SizedBox(height: tablet ? 8 : 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: tablet ? 14 : 10.5,
            ),
          ),
        ],
      ),
    );
  }
}
