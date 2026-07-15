import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../l10n/strings.dart';
import '../models/models.dart';
import '../services/sound_service.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/car_3d_viewer.dart';
import 'package:hugeicons/hugeicons.dart';

class _PaintOption {
  final String label;
  final Color color;
  const _PaintOption(this.label, this.color);
}

class _CameraPreset {
  final String labelKey;
  final String orbit;
  final String target;
  const _CameraPreset(
    this.labelKey,
    this.orbit, {
    this.target = 'auto auto auto',
  });
}

// Real-world showroom colors — the palette every mainstream sedan/SUV is
// actually sold in, not a generic rainbow of web colors.
const List<_PaintOption> _kPaintOptions = [
  _PaintOption('White', Color(0xFFF2F3F5)),
  _PaintOption('Silver', Color(0xFFC8CDD1)),
  _PaintOption('Gray', Color(0xFF54585C)),
  _PaintOption('Black', Color(0xFF0A0A0C)),
  _PaintOption('Red', AppColors.bmwBlue),
  _PaintOption('Maroon', Color(0xFF6B1522)),
  _PaintOption('Blue', Color(0xFF1E3F73)),
  _PaintOption('Green', Color(0xFF2F4538)),
  _PaintOption('Beige', Color(0xFFC9B896)),
];

const List<_CameraPreset> _kCameraPresets = [
  _CameraPreset('camera_front', '0deg 78deg 105%'),
  _CameraPreset('camera_side', '90deg 80deg 105%'),
  _CameraPreset('camera_rear', '180deg 78deg 105%'),
  _CameraPreset('camera_34', '25deg 78deg 105%'),
  _CameraPreset('camera_interior', '20deg 85deg 6%', target: '0m 1m 0.3m'),
];

class Car3DFullscreenScreen extends StatefulWidget {
  final Vehicle vehicle;

  const Car3DFullscreenScreen({super.key, required this.vehicle});

  @override
  State<Car3DFullscreenScreen> createState() => _Car3DFullscreenScreenState();
}

class _Car3DFullscreenScreenState extends State<Car3DFullscreenScreen>
    with SingleTickerProviderStateMixin {
  late final Car3DViewerController _controller;
  late final AnimationController _shakeController;
  int _selectedColorIndex = -1;
  int _selectedCameraIndex = 3;

  @override
  void initState() {
    super.initState();
    _controller = Car3DViewerController(
      paintMaterialName: widget.vehicle.paintMaterialName,
    );
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _pickColor(int index) {
    setState(() => _selectedColorIndex = index);
    _controller.setPaintColor(_kPaintOptions[index].color);
    SoundService.instance.play(SoundEffect.tap, volume: .3);
    HapticFeedback.selectionClick();
  }

  void _pickCamera(int index) {
    setState(() => _selectedCameraIndex = index);
    _controller.setCameraTarget(_kCameraPresets[index].target);
    _controller.setCameraOrbit(_kCameraPresets[index].orbit);
    SoundService.instance.play(SoundEffect.tap, volume: .2);
    HapticFeedback.selectionClick();
  }

  void _startEngine() {
    SoundService.instance.play(SoundEffect.engineStart);
    HapticFeedback.heavyImpact();
    _shakeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final tablet = context.isTablet;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemOverlay.forDarkScreens,
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: tablet ? 16 : 8,
                  vertical: tablet ? 8 : 4,
                ),
                child: Row(
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
                        widget.vehicle.model,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: tablet ? 21 : 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: tablet ? 56 : 48),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Spotlight backdrop.
                    Container(
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(0, -0.1),
                          radius: 1.0,
                          colors: [Color(0xFF26272B), AppColors.black],
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, 0.55),
                      child: Container(
                        width: 220,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.6),
                              blurRadius: 40,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Car3DViewer(
                          modelAsset: widget.vehicle.modelAsset,
                          controller: _controller,
                        )
                        .animate(controller: _shakeController, autoPlay: false)
                        .shake(
                          hz: 6,
                          rotation: 0,
                          offset: const Offset(3, 0),
                          duration: const Duration(milliseconds: 700),
                        ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedSwipeLeft01,
                    color: Colors.white54,
                    size: tablet ? 18 : 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.tr('drag_to_rotate'),
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: tablet ? 14 : 12,
                    ),
                  ),
                ],
              ),
              SizedBox(height: tablet ? 20 : 16),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: tablet ? 640 : double.infinity,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(_kCameraPresets.length, (i) {
                        final selected = i == _selectedCameraIndex;
                        return GestureDetector(
                          onTap: () => _pickCamera(i),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: tablet ? 22 : 16,
                              vertical: tablet ? 12 : 8,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.bmwBlue
                                  : Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              context.tr(_kCameraPresets[i].labelKey),
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w600,
                                fontSize: tablet ? 15 : 12.5,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              SizedBox(height: tablet ? 22 : 18),
              Text(
                context.tr('paint_color'),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: tablet ? 14 : 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: tablet ? 56 : 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _kPaintOptions.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final selected = i == _selectedColorIndex;
                    final swatchSize = tablet ? 48.0 : 36.0;
                    return GestureDetector(
                      onTap: () => _pickColor(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: swatchSize,
                        height: swatchSize,
                        decoration: BoxDecoration(
                          color: _kPaintOptions[i].color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.2),
                            width: selected ? 3 : 1,
                          ),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: _kPaintOptions[i].color.withValues(
                                      alpha: 0.6,
                                    ),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: tablet ? 24 : 20),
              GestureDetector(
                onTap: _startEngine,
                child:
                    Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: tablet ? 36 : 28,
                            vertical: tablet ? 18 : 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.bmwBlue,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.bmwBlue.withValues(
                                  alpha: 0.5,
                                ),
                                blurRadius: 20,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedPower,
                                color: Colors.white,
                                size: tablet ? 22 : 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                context.tr('engine_start'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: tablet ? 17 : 14,
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scaleXY(
                          begin: 1.0,
                          end: 1.04,
                          duration: const Duration(milliseconds: 900),
                          curve: Curves.easeInOut,
                        ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
