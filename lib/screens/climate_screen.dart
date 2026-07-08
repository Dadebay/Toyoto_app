import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/strings.dart';
import '../services/sound_service.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import 'package:hugeicons/hugeicons.dart';

class ClimateScreen extends StatefulWidget {
  const ClimateScreen({super.key});

  @override
  State<ClimateScreen> createState() => _ClimateScreenState();
}

class _ClimateScreenState extends State<ClimateScreen> {
  int _temp = 21;
  int _fanLevel = 2;
  bool _acOn = true;
  bool _autoOn = false;
  bool _defrostOn = false;
  bool _recirculateOn = false;
  bool _driverSeatHeat = false;
  bool _passengerSeatHeat = false;

  void _changeTemp(int delta) {
    HapticFeedback.selectionClick();
    setState(() => _temp = (_temp + delta).clamp(16, 30));
  }

  void _toggle(void Function(bool) setter, bool current) {
    HapticFeedback.selectionClick();
    SoundService.instance.play(SoundEffect.tap, volume: 0.2);
    setState(() => setter(!current));
  }

  Widget _tempControl(bool tablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoundIconButton(
          icon: HugeIcons.strokeRoundedMinusSignCircle,
          onTap: () => _changeTemp(-1),
          tablet: tablet,
        ),
        SizedBox(
          width: tablet ? 170 : 140,
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$_temp',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: tablet ? 72 : 56,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    TextSpan(
                      text: '°C',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: tablet ? 26 : 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _RoundIconButton(
          icon: HugeIcons.strokeRoundedPlusSignCircle,
          onTap: () => _changeTemp(1),
          tablet: tablet,
        ),
      ],
    );
  }

  Widget _fanSpeedControl(bool tablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('fan_speed'),
          style: TextStyle(
            color: Colors.white70,
            fontSize: tablet ? 15 : 12.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (i) {
            final on = i > 0;
            final active = i <= _fanLevel;
            final barWidth = tablet ? 28.0 : 22.0;
            return GestureDetector(
              onTap: on
                  ? () {
                      HapticFeedback.selectionClick();
                      setState(() => _fanLevel = i);
                    }
                  : null,
              child: Column(
                children: [
                  if (i == 0)
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedFan01,
                      color: _fanLevel == 0
                          ? AppColors.toyotaRed
                          : Colors.white54,
                      size: tablet ? 28 : 22,
                    )
                  else
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: barWidth,
                      height: (tablet ? 18.0 : 14.0) + i * (tablet ? 10 : 8),
                      decoration: BoxDecoration(
                        color: active ? AppColors.toyotaRed : Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    i == 0 ? '0' : '$i',
                    style: TextStyle(
                      color: i == _fanLevel
                          ? AppColors.toyotaRed
                          : Colors.white54,
                      fontSize: tablet ? 13 : 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _toggleSections(bool tablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _ToggleCard(
                icon: HugeIcons.strokeRoundedSnow,
                label: context.tr('ac'),
                on: _acOn,
                onTap: () => _toggle((v) => _acOn = v, _acOn),
                tablet: tablet,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ToggleCard(
                icon: HugeIcons.strokeRoundedRefresh,
                label: context.tr('auto'),
                on: _autoOn,
                onTap: () => _toggle((v) => _autoOn = v, _autoOn),
                tablet: tablet,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _ToggleCard(
                icon: HugeIcons.strokeRoundedSun01,
                label: context.tr('defrost'),
                on: _defrostOn,
                onTap: () => _toggle((v) => _defrostOn = v, _defrostOn),
                tablet: tablet,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ToggleCard(
                icon: HugeIcons.strokeRoundedRecycle01,
                label: context.tr('recirculate'),
                on: _recirculateOn,
                onTap: () => _toggle((v) => _recirculateOn = v, _recirculateOn),
                tablet: tablet,
              ),
            ),
          ],
        ),
        SizedBox(height: tablet ? 34 : 28),
        Text(
          context.tr('seat_heating'),
          style: TextStyle(
            color: Colors.white70,
            fontSize: tablet ? 15 : 12.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _ToggleCard(
                icon: HugeIcons.strokeRoundedThermometerWarm,
                label: context.tr('driver_seat'),
                on: _driverSeatHeat,
                onTap: () =>
                    _toggle((v) => _driverSeatHeat = v, _driverSeatHeat),
                tablet: tablet,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ToggleCard(
                icon: HugeIcons.strokeRoundedThermometerWarm,
                label: context.tr('passenger_seat'),
                on: _passengerSeatHeat,
                onTap: () =>
                    _toggle((v) => _passengerSeatHeat = v, _passengerSeatHeat),
                tablet: tablet,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tablet = context.isTablet;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemOverlay.forDarkScreens,
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft02,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          title: Text(
            context.tr('climate_title'),
            style: TextStyle(
              color: Colors.white,
              fontSize: tablet ? 21 : 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          child: tablet ? _buildTabletLayout() : _buildPhoneLayout(),
        ),
      ),
    );
  }

  Widget _buildPhoneLayout() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      children: [
        _tempControl(false),
        const SizedBox(height: 32),
        _fanSpeedControl(false),
        const SizedBox(height: 32),
        _toggleSections(false),
      ],
    );
  }

  /// iPad puts the temperature/fan dial (tap-only, not drag-driven) in a
  /// fixed-width left column and the toggle grid in a wider right column,
  /// instead of stacking everything in one centered phone-width column.
  Widget _buildTabletLayout() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 320,
              child: Column(
                children: [
                  _tempControl(true),
                  const SizedBox(height: 40),
                  _fanSpeedControl(true),
                ],
              ),
            ),
            const SizedBox(width: 40),
            Expanded(child: _toggleSections(true)),
          ],
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final List<List<dynamic>> icon;
  final VoidCallback onTap;
  final bool tablet;

  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    this.tablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: HugeIcon(icon: icon, color: Colors.white, size: tablet ? 42 : 34),
    );
  }
}

class _ToggleCard extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String label;
  final bool on;
  final VoidCallback onTap;
  final bool tablet;

  const _ToggleCard({
    required this.icon,
    required this.label,
    required this.on,
    required this.onTap,
    this.tablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: tablet ? 22 : 16,
          horizontal: tablet ? 16 : 12,
        ),
        decoration: BoxDecoration(
          color: on
              ? AppColors.toyotaRed.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: on
                ? AppColors.toyotaRed
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            HugeIcon(
              icon: icon,
              color: on ? AppColors.toyotaRed : Colors.white70,
              size: tablet ? 28 : 22,
            ),
            SizedBox(height: tablet ? 10 : 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: on ? Colors.white : Colors.white70,
                fontSize: tablet ? 14 : 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
