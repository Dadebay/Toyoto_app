import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../data/mock_data.dart';
import '../l10n/strings.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_back_button.dart';
import 'package:hugeicons/hugeicons.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late final MapController _mapController;
  late int _selected;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _selected = MockData.vehicles.indexOf(MockData.myVehicle);
  }

  void _selectVehicle(int index) {
    setState(() => _selected = index);
    final v = MockData.vehicles[index];
    _mapController.move(LatLng(v.latitude, v.longitude), 15);
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = MockData.vehicles;
    final selectedVehicle = vehicles[_selected];
    final points = vehicles
        .map((v) => LatLng(v.latitude, v.longitude))
        .toList();
    final tablet = context.isTablet;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(context.tr('location_title')),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCameraFit: CameraFit.bounds(
                bounds: LatLngBounds.fromPoints(points),
                padding: const EdgeInsets.fromLTRB(60, 100, 60, 220),
              ),
              minZoom: 5,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://map.ayterek.com/tile/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.toyotatm.mobileapp',
              ),
              MarkerLayer(
                markers: List.generate(vehicles.length, (i) {
                  final v = vehicles[i];
                  final selected = i == _selected;
                  return Marker(
                    point: LatLng(v.latitude, v.longitude),
                    width: 60,
                    height: 84,
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () => _selectVehicle(i),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.toyotaRed
                                  : AppColors.black,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (selected
                                              ? AppColors.toyotaRed
                                              : AppColors.black)
                                          .withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  spreadRadius: selected ? 3 : 0,
                                ),
                              ],
                            ),
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedCar02,
                              color: Colors.white,
                              size: selected ? 22 : 18,
                            ),
                          ),
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowDown01,
                            color: selected
                                ? AppColors.toyotaRed
                                : AppColors.black,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          // On iPad the card reads as a floating side panel (fixed width,
          // anchored top-left) instead of a phone-style bottom banner, since
          // stretching it edge-to-edge on a wide screen looks unbalanced.
          tablet
              ? Positioned(
                  left: 20,
                  top: 20,
                  width: 360,
                  child: _VehicleLocationCard(
                    vehicle: selectedVehicle,
                    tablet: true,
                  ),
                )
              : Positioned(
                  left: 16,
                  right: 16,
                  bottom: 24,
                  child: _VehicleLocationCard(vehicle: selectedVehicle),
                ),
        ],
      ),
    );
  }
}

class _VehicleLocationCard extends StatelessWidget {
  final Vehicle vehicle;
  final bool tablet;

  const _VehicleLocationCard({required this.vehicle, this.tablet = false});

  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.all(tablet ? 10 : 8),
                decoration: BoxDecoration(
                  color: AppColors.toyotaRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedCar02,
                  color: AppColors.toyotaRed,
                  size: tablet ? 19 : 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  vehicle.model,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: tablet ? 17 : 14.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            vehicle.address,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: tablet ? 15 : 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${context.tr('last_updated')}: 2 min ago',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: tablet ? 13 : null),
          ),
          SizedBox(height: tablet ? 18 : 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedRoute02,
                size: tablet ? 22 : 20,
              ),
              label: Text(context.tr('get_directions')),
              style: tablet
                  ? ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
