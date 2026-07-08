import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../models/models.dart';
import '../screens/car_3d_fullscreen_screen.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import 'car_3d_viewer.dart';
import 'package:hugeicons/hugeicons.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final tablet = context.isTablet;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.black, AppColors.charcoal],
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vehicle.model,
            style: TextStyle(
              color: Colors.white,
              fontSize: tablet ? 26 : 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${context.tr('vin_label')}: ${vehicle.vin}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: tablet ? 13 : 12,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Car3DFullscreenScreen(vehicle: vehicle),
              ),
            ),
            child: SizedBox(
              height: tablet ? 280 : 190,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Car3DViewer(modelAsset: vehicle.modelAsset),
                  ),
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedSwipeLeft01,
                            color: Colors.white70,
                            size: 13,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            context.tr('drag_to_rotate'),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: tablet ? 20 : 16),
          Row(
            children: [
              Expanded(
                child: _statTile(
                  context,
                  HugeIcons.strokeRoundedDashboardSpeed01,
                  context.tr('mileage_label'),
                  '${vehicle.mileageKm} km',
                  tablet: tablet,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statTile(
                  context,
                  HugeIcons.strokeRoundedFuelStation,
                  context.tr('qa_fuel'),
                  '${(vehicle.fuelPercent * 100).round()}%',
                  tablet: tablet,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statTile(
    BuildContext context,
    List<List<dynamic>> icon,
    String label,
    String value, {
    required bool tablet,
  }) {
    return Container(
      padding: EdgeInsets.all(tablet ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          HugeIcon(
            icon: icon,
            color: Colors.white.withValues(alpha: 0.8),
            size: tablet ? 22 : 18,
          ),
          SizedBox(width: tablet ? 10 : 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: tablet ? 17 : 14,
                  ),
                ),
                Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: tablet ? 12 : 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
