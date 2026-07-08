import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../l10n/strings.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/section_header.dart';
import '../widgets/toyota_badge.dart';
import '../widgets/vehicle_card.dart';
import '../utils/responsive.dart';
import 'book_service_screen.dart';
import 'health_check_screen.dart';
import 'location_screen.dart';
import 'nearby_service_screen.dart';
import 'notifications_screen.dart';
import 'remote_connect_screen.dart';
import 'package:hugeicons/hugeicons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selected = MockData.vehicles.indexOf(MockData.camry2020);
  final Set<int> _loadedVehicles = {};

  @override
  void initState() {
    super.initState();
    _loadedVehicles.add(_selected);
  }

  List<QuickAction> _quickActions(BuildContext context) {
    return [
      QuickAction(
        icon: HugeIcons.strokeRoundedSquareUnlock01,
        label: context.tr('qa_remote'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RemoteConnectScreen()),
        ),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedMapsLocation02,
        label: context.tr('qa_location'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LocationScreen()),
        ),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedCustomerSupport,
        label: context.tr('qa_nearby_service'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NearbyServiceScreen()),
        ),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedCalendar03,
        label: context.tr('qa_service_booking'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BookServiceScreen()),
        ),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedFavourite,
        label: context.tr('qa_health'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HealthCheckScreen()),
        ),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedShieldUser,
        label: context.tr('qa_warranty'),
        onTap: () => _showInfo(
          context,
          context.tr('qa_warranty'),
          '3 ýyl / 100,000 km · Active',
        ),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedHeadphones,
        label: context.tr('qa_support'),
        onTap: () =>
            _showInfo(context, context.tr('qa_support'), '+993 12 456 789'),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedNotification02,
        label: context.tr('qa_notifications'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
        ),
      ),
    ];
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        const ToyotaBadge(size: 42),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('greeting'),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                context.tr('greeting_sub'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider),
            ),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedNotification01,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _vehicleChips(BuildContext context, List<Vehicle> vehicles) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: vehicles.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final selected = i == _selected;
          return ChoiceChip(
            selected: selected,
            label: Text(vehicles[i].model),
            onSelected: (_) => setState(() {
              _selected = i;
              _loadedVehicles.add(i);
            }),
            selectedColor: AppColors.toyotaRed,
            backgroundColor: AppColors.card,
            labelStyle: TextStyle(
              color: selected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: AppColors.divider),
            ),
          );
        },
      ),
    );
  }

  Widget _upcomingServiceCard(BuildContext context, Vehicle vehicle) {
    return AppCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BookServiceScreen()),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.toyotaRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedWrench02,
              color: AppColors.toyotaRed,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('upcoming_service'),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  '${vehicle.nextServiceKm} km · ${vehicle.nextServiceDate.day}.${vehicle.nextServiceDate.month}.${vehicle.nextServiceDate.year}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          HugeIcon(
            icon: HugeIcons.strokeRoundedArrowRight01,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: context.isTablet
          ? _buildTabletLayout(context)
          : _buildPhoneLayout(context),
    );
  }

  Widget _buildPhoneLayout(BuildContext context) {
    final vehicles = MockData.vehicles;
    final vehicle = vehicles[_selected];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      children: [
        _header(context),
        const SizedBox(height: 18),
        _vehicleChips(context, vehicles),
        const SizedBox(height: 14),
        IndexedStack(
          index: _selected,
          children: List.generate(vehicles.length, (i) {
            if (!_loadedVehicles.contains(i)) return const SizedBox.shrink();
            return VehicleCard(
              key: ValueKey(vehicles[i].vin),
              vehicle: vehicles[i],
            );
          }),
        ),
        const SizedBox(height: 14),
        _upcomingServiceCard(context, vehicle),
        const SizedBox(height: 24),
        SectionHeader(title: context.tr('nav_home')),
        const SizedBox(height: 14),
        QuickActionGrid(actions: _quickActions(context)),
      ],
    );
  }

  /// iPad keeps the same top-to-bottom flow as the phone (the 3D vehicle
  /// card needs full width to stay usable for drag-to-rotate — splitting it
  /// into a sidebar column shrinks and isolates it), just with generous page
  /// padding instead of a centered fixed-width column, so every section
  /// (vehicle card, quick actions grid) actually stretches to use the width.
  Widget _buildTabletLayout(BuildContext context) {
    final vehicles = MockData.vehicles;
    final vehicle = vehicles[_selected];

    return ListView(
      padding: const EdgeInsets.fromLTRB(40, 16, 40, 100),
      children: [
        _header(context),
        const SizedBox(height: 22),
        _vehicleChips(context, vehicles),
        const SizedBox(height: 18),
        IndexedStack(
          index: _selected,
          children: List.generate(vehicles.length, (i) {
            if (!_loadedVehicles.contains(i)) return const SizedBox.shrink();
            return VehicleCard(
              key: ValueKey(vehicles[i].vin),
              vehicle: vehicles[i],
            );
          }),
        ),
        const SizedBox(height: 18),
        _upcomingServiceCard(context, vehicle),
        const SizedBox(height: 28),
        SectionHeader(title: context.tr('nav_home')),
        const SizedBox(height: 16),
        QuickActionGrid(actions: _quickActions(context)),
      ],
    );
  }

  void _showInfo(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
