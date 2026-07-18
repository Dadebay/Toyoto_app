import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../l10n/strings.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/campaign_carousel.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/section_header.dart';
import '../widgets/bmw_badge.dart';
import '../widgets/vehicle_card.dart';
import '../utils/responsive.dart';
import 'book_service_screen.dart';
import 'health_check_screen.dart';
import 'location_screen.dart';
import 'nearby_service_screen.dart';
import 'notifications_screen.dart';
import 'remote_connect_screen.dart';
import 'service_tracking_screen.dart';
import 'showroom_screen.dart';
import 'test_drive_screen.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selected = MockData.vehicles.indexOf(MockData.myVehicle);

  List<QuickAction> _quickActions(BuildContext context) {
    return [
      QuickAction(
        icon: HugeIcons.strokeRoundedCar05,
        label: context.tr('qa_showroom'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShowroomScreen())),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedSteering,
        label: context.tr('qa_test_drive'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TestDriveScreen())),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedSquareUnlock01,
        label: context.tr('qa_remote'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RemoteConnectScreen())),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedMapsLocation02,
        label: context.tr('qa_location'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LocationScreen())),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedCustomerSupport,
        label: context.tr('qa_nearby_service'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NearbyServiceScreen())),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedCalendar03,
        label: context.tr('qa_service_booking'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BookServiceScreen())),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedFavourite,
        label: context.tr('qa_health'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HealthCheckScreen())),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedShieldUser,
        label: context.tr('qa_warranty'),
        onTap: () => _showInfo(context, icon: HugeIcons.strokeRoundedShieldUser, title: context.tr('qa_warranty'), body: '3 ýyl / 100,000 km · Active'),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedHeadphones,
        label: context.tr('qa_support'),
        onTap: () => _showInfo(context, icon: HugeIcons.strokeRoundedHeadphones, title: context.tr('qa_support'), body: '+993 12 456 789'),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedNotification02,
        label: context.tr('qa_notifications'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
      ),
    ];
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        const BmwBadge(size: 42),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.tr('greeting'), style: Theme.of(context).textTheme.headlineMedium),
              Text(context.tr('greeting_sub'), style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider),
            ),
            child: HugeIcon(icon: HugeIcons.strokeRoundedNotification01, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  List<List<dynamic>> _bodyIcon(String model) {
    if (model.contains('X6') || model.contains('XB7') || model.contains('X7')) {
      return HugeIcons.strokeRoundedCar01;
    }
    if (model.contains('340i') || model.contains('530i') || model.contains('550i')) {
      return HugeIcons.strokeRoundedCar02;
    }
    return HugeIcons.strokeRoundedCar05;
  }

  Widget _vehicleChips(BuildContext context, List<Vehicle> vehicles) {
    final tablet = context.isTablet;
    return SizedBox(
      height: tablet ? 68 : 58,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: vehicles.length,
        separatorBuilder: (_, _) => SizedBox(width: tablet ? 12 : 10),
        itemBuilder: (context, i) {
          final vehicle = vehicles[i];
          final selected = i == _selected;
          return GestureDetector(
            onTap: () => setState(() => _selected = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              padding: EdgeInsets.symmetric(horizontal: tablet ? 16 : 12, vertical: tablet ? 8 : 6),
              decoration: BoxDecoration(
                color: selected ? AppColors.bmwBlue : AppColors.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: selected ? AppColors.bmwBlue : AppColors.divider),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppColors.bmwBlue.withValues(alpha: 0.3),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: tablet ? 34 : 28,
                    height: tablet ? 34 : 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? Colors.white.withValues(alpha: 0.18) : AppColors.bmwBlue.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: HugeIcon(
                      icon: _bodyIcon(vehicle.model),
                      color: selected ? Colors.white : AppColors.bmwBlue,
                      size: tablet ? 18 : 15,
                    ),
                  ),
                  SizedBox(width: tablet ? 10 : 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        vehicle.model,
                        style: TextStyle(
                          color: selected ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: tablet ? 14.5 : 12.5,
                          height: 1.1,
                        ),
                      ),
                      if (selected) ...[
                        const SizedBox(height: 2),
                        Text(
                          vehicle.plate,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontWeight: FontWeight.w600,
                            fontSize: tablet ? 11.5 : 10,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _upcomingServiceCard(BuildContext context, Vehicle vehicle) {
    return AppCard(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BookServiceScreen())),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.bmwBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: HugeIcon(icon: HugeIcons.strokeRoundedWrench02, color: AppColors.bmwBlue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tr('upcoming_service'), style: const TextStyle(fontWeight: FontWeight.w700)),
                Text('${vehicle.nextServiceKm} km · ${vehicle.nextServiceDate.day}.${vehicle.nextServiceDate.month}.${vehicle.nextServiceDate.year}', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _activeServiceCard(BuildContext context, ServiceTicket ticket) {
    return AppCard(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServiceTrackingScreen())),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: HugeIcon(icon: HugeIcons.strokeRoundedWrench01, color: AppColors.warning),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tr('svc_home_card_title'), style: const TextStyle(fontWeight: FontWeight.w700)),
                Text('${context.tr('svc_step_label')} ${ticket.currentStep}/5', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppState>();
    return SafeArea(child: context.isTablet ? _buildTabletLayout(context) : _buildPhoneLayout(context));
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
        VehicleCard(key: ValueKey(vehicle.vin), vehicle: vehicle),
        const SizedBox(height: 18),
        const CampaignCarousel(),
        const SizedBox(height: 14),
        _upcomingServiceCard(context, vehicle),
        if (context.watch<AppState>().activeServiceTicket != null) ...[const SizedBox(height: 14), _activeServiceCard(context, context.watch<AppState>().activeServiceTicket!)],
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
        VehicleCard(key: ValueKey(vehicle.vin), vehicle: vehicle),
        const SizedBox(height: 22),
        const CampaignCarousel(),
        const SizedBox(height: 18),
        _upcomingServiceCard(context, vehicle),
        if (context.watch<AppState>().activeServiceTicket != null) ...[const SizedBox(height: 18), _activeServiceCard(context, context.watch<AppState>().activeServiceTicket!)],
        const SizedBox(height: 28),
        SectionHeader(title: context.tr('nav_home')),
        const SizedBox(height: 16),
        QuickActionGrid(actions: _quickActions(context)),
      ],
    );
  }

  void _showInfo(BuildContext context, {required List<List<dynamic>> icon, required String title, required String body}) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 36),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColors.bmwBlue.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: HugeIcon(icon: icon, color: AppColors.bmwBlue, size: 28),
              ),
              const SizedBox(height: 18),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(body, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => Navigator.pop(context), child: Text(context.tr('got_it'))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
