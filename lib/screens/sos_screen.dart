import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../data/mock_data.dart';
import '../l10n/strings.dart';
import '../services/sound_service.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_back_button.dart';
import 'package:hugeicons/hugeicons.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fillController;
  late final List<LatLng> _route;
  Timer? _moveTimer;
  double _routeT = 0;
  bool _dispatched = false;

  @override
  void initState() {
    super.initState();
    _fillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) _dispatch();
    });

    final v = MockData.myVehicle;
    final destination = LatLng(v.latitude, v.longitude);
    final start = LatLng(v.latitude + 0.018, v.longitude - 0.02);
    final mid = LatLng(
      (start.latitude + destination.latitude) / 2 + 0.006,
      (start.longitude + destination.longitude) / 2 - 0.006,
    );
    _route = [start, mid, destination];
  }

  @override
  void dispose() {
    _fillController.dispose();
    _moveTimer?.cancel();
    super.dispose();
  }

  void _dispatch() {
    if (_dispatched) return;
    setState(() => _dispatched = true);
    SoundService.instance.play(SoundEffect.whoosh);
    HapticFeedback.heavyImpact();

    const tick = Duration(milliseconds: 200);
    const totalTicks = 125; // ~25s on-screen animation
    int elapsed = 0;
    _moveTimer = Timer.periodic(tick, (timer) {
      elapsed++;
      final t = (elapsed / totalTicks).clamp(0.0, 1.0);
      setState(() => _routeT = t);
      if (t >= 1.0) {
        timer.cancel();
        SoundService.instance.play(SoundEffect.success);
      }
    });
  }

  LatLng _positionAlongRoute(double t) {
    if (t <= 0.5) {
      final segT = t / 0.5;
      return LatLng(
        _route[0].latitude + (_route[1].latitude - _route[0].latitude) * segT,
        _route[0].longitude +
            (_route[1].longitude - _route[0].longitude) * segT,
      );
    }
    final segT = (t - 0.5) / 0.5;
    return LatLng(
      _route[1].latitude + (_route[2].latitude - _route[1].latitude) * segT,
      _route[1].longitude + (_route[2].longitude - _route[1].longitude) * segT,
    );
  }

  Widget _callButton(double size) {
    return GestureDetector(
      onLongPressStart: (_) => _fillController.forward(),
      onLongPressEnd: (_) {
        if (_fillController.status != AnimationStatus.completed) {
          _fillController.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _fillController,
        builder: (context, child) => CustomPaint(
          painter: _FillRingPainter(
            progress: _fillController.value,
            color: AppColors.toyotaRed,
          ),
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              child: Container(
                width: size * 0.76,
                height: size * 0.76,
                decoration: const BoxDecoration(
                  color: AppColors.toyotaRed,
                  shape: BoxShape.circle,
                ),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedAlert02,
                  color: Colors.white,
                  size: size * 0.32,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusCard(bool tablet) {
    return Container(
      padding: EdgeInsets.all(tablet ? 22 : 18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.toyotaRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedCarAlert,
                  color: AppColors.toyotaRed,
                  size: tablet ? 20 : 17,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.tr('sos_help_dispatched'),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: tablet ? 17 : 14.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            context.tr('sos_eta_minutes'),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: tablet ? 14 : null),
          ),
          SizedBox(height: tablet ? 18 : 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.toyotaRed,
                side: const BorderSide(color: AppColors.toyotaRed),
                padding: EdgeInsets.symmetric(vertical: tablet ? 16 : 14),
              ),
              child: Text(context.tr('sos_cancel_request')),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tablet = context.isTablet;
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(context.tr('sos_title')),
      ),
      body: _dispatched ? _buildDispatchView(tablet) : _buildCallView(tablet),
    );
  }

  Widget _buildCallView(bool tablet) {
    final size = tablet ? 220.0 : 170.0;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              context.tr('sos_hold_to_call'),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: tablet ? 16 : null),
            ),
          ),
          const SizedBox(height: 40),
          _callButton(size),
        ],
      ),
    );
  }

  Widget _buildDispatchView(bool tablet) {
    final vehicle = MockData.myVehicle;
    final vehiclePoint = LatLng(vehicle.latitude, vehicle.longitude);
    final truckPoint = _positionAlongRoute(_routeT);

    final map = FlutterMap(
      options: MapOptions(
        initialCenter: vehiclePoint,
        initialZoom: 14,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://map.ayterek.com/tile/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.toyotatm.mobileapp',
        ),
        PolylineLayer(
          polylines: [
            Polyline(points: _route, strokeWidth: 3, color: AppColors.toyotaRed.withValues(alpha: 0.6)),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: vehiclePoint,
              width: 46,
              height: 46,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.black,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedCar02,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            Marker(
              point: truckPoint,
              width: 46,
              height: 46,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.toyotaRed,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedCarAlert,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );

    if (tablet) {
      return Stack(
        children: [
          map,
          Positioned(left: 20, top: 20, width: 380, child: _statusCard(true)),
        ],
      );
    }

    return Stack(
      children: [
        map,
        Positioned(left: 16, right: 16, bottom: 24, child: _statusCard(false)),
      ],
    );
  }
}

class _FillRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _FillRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.055;
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final track = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(rect, 0, 2 * pi, false, track);

    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, fill);
  }

  @override
  bool shouldRepaint(covariant _FillRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
