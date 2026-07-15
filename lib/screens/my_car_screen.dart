import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../l10n/model_localization.dart';
import '../l10n/strings.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/section_header.dart';
import '../widgets/vehicle_card.dart';
import '../utils/responsive.dart';
import 'book_service_screen.dart';
import 'climate_screen.dart';
import 'health_check_screen.dart';
import 'location_screen.dart';
import 'expenses_screen.dart';
import 'notifications_screen.dart';
import 'service_history_screen.dart';
import 'service_tracking_screen.dart';
import 'trade_in_screen.dart';
import 'package:hugeicons/hugeicons.dart';

class MyCarScreen extends StatefulWidget {
  const MyCarScreen({super.key});

  @override
  State<MyCarScreen> createState() => _MyCarScreenState();
}

class _MyCarScreenState extends State<MyCarScreen> {
  int _selected = 0;
  // Tracks which vehicles' 3D cards have been built at least once, so
  // switching back to an already-viewed vehicle is instant instead of
  // re-loading its model from scratch every time.
  final Set<int> _loadedVehicles = {0};

  List<QuickAction> _quickActions(BuildContext context, Vehicle vehicle) {
    return [
      QuickAction(
        icon: HugeIcons.strokeRoundedFuelStation,
        label: context.tr('qa_fuel'),
        onTap: () => _showInfo(
          context,
          icon: HugeIcons.strokeRoundedFuelStation,
          title: context.tr('qa_fuel'),
          body: '${(vehicle.fuelPercent * 100).round()}% · ~510 km',
        ),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedSettings02,
        label: context.tr('qa_engine_report'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HealthCheckScreen()),
        ),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedSnow,
        label: context.tr('qa_climate'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ClimateScreen()),
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
        icon: HugeIcons.strokeRoundedFile02,
        label: context.tr('qa_service_report'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HealthCheckScreen()),
        ),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedWrench01,
        label: context.tr('qa_service'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BookServiceScreen()),
        ),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedShieldUser,
        label: context.tr('qa_warranty'),
        onTap: () => _showInfo(
          context,
          icon: HugeIcons.strokeRoundedShieldUser,
          title: context.tr('qa_warranty'),
          body: '3 ýyl / 100,000 km · Active',
        ),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedNotification01,
        label: context.tr('qa_notifications'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
        ),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedExchange02,
        label: context.tr('qa_trade_in'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TradeInScreen()),
        ),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedFile02,
        label: context.tr('qa_service_history'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceHistoryScreen(vehicle: vehicle),
          ),
        ),
      ),
      QuickAction(
        icon: HugeIcons.strokeRoundedChartBarLine,
        label: context.tr('qa_expenses'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ExpensesScreen()),
        ),
      ),
    ];
  }

  Widget _vehicleChips(
    BuildContext context,
    List<Vehicle> vehicles,
    bool tablet,
  ) {
    return SizedBox(
      height: tablet ? 44 : 36,
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
            selectedColor: AppColors.bmwBlue,
            backgroundColor: AppColors.card,
            labelStyle: TextStyle(
              color: selected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: tablet ? 14.5 : 12.5,
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

  Widget _serviceHistoryCard(BuildContext context, Vehicle vehicle, bool tablet) {
    final lang = context.watch<AppState>().language;
    final records = MockData.serviceHistory
        .where((r) => r.vehicle == vehicle)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    final preview = records.take(3).toList();

    if (preview.isEmpty) {
      return AppCard(
        child: Text(
          context.tr('svc_history_empty'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: List.generate(preview.length, (i) {
          final item = preview[i];
          final isLast = i == preview.length - 1;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(tablet ? 20 : 16),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(tablet ? 14 : 10),
                      decoration: BoxDecoration(
                        color: AppColors.bmwBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedWrench01,
                        color: AppColors.bmwBlue,
                        size: tablet ? 26 : 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.description(lang),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: tablet ? 16 : 13.5,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${item.date.day}.${item.date.month}.${item.date.year}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontSize: tablet ? 14 : null),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: tablet ? 12 : 9,
                        vertical: tablet ? 7 : 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedTick01,
                            color: AppColors.success,
                            size: tablet ? 15 : 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.tr('completed'),
                            style: TextStyle(
                              color: AppColors.success,
                              fontWeight: FontWeight.w700,
                              fontSize: tablet ? 12.5 : 10.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }),
      ),
    );
  }

  Widget _activeServiceCard(BuildContext context, ServiceTicket ticket) {
    return AppCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ServiceTrackingScreen()),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedWrench01,
              color: AppColors.warning,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('svc_home_card_title'),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  '${context.tr('svc_step_label')} ${ticket.currentStep}/5',
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
    context.watch<AppState>();
    return Scaffold(
      body: SafeArea(
        child: context.isTablet
            ? _buildTabletLayout(context)
            : _buildPhoneLayout(context),
      ),
    );
  }

  Widget _buildPhoneLayout(BuildContext context) {
    final vehicles = MockData.vehicles;
    final vehicle = vehicles[_selected];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        Text(
          context.tr('my_car_title'),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        _vehicleChips(context, vehicles, false),
        const SizedBox(height: 16),
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
        if (context.watch<AppState>().activeServiceTicket != null) ...[
          const SizedBox(height: 16),
          _activeServiceCard(context, context.watch<AppState>().activeServiceTicket!),
        ],
        const SizedBox(height: 24),
        SectionHeader(title: context.tr('my_car_title')),
        const SizedBox(height: 14),
        QuickActionGrid(actions: _quickActions(context, vehicle)),
        const SizedBox(height: 24),
        SectionHeader(
          title: context.tr('qa_service_report'),
          actionLabel: context.tr('see_all'),
          onAction: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ServiceHistoryScreen(vehicle: vehicle),
            ),
          ),
        ),
        const SizedBox(height: 14),
        _serviceHistoryCard(context, vehicle, false),
      ],
    );
  }

  /// iPad keeps the same top-to-bottom flow as the phone — the 3D vehicle
  /// card needs full width to stay usable for drag-to-rotate, so it isn't
  /// squeezed into a sidebar column — just with generous page padding and
  /// tablet-scaled sections instead of a centered fixed-width column.
  Widget _buildTabletLayout(BuildContext context) {
    final vehicles = MockData.vehicles;
    final vehicle = vehicles[_selected];

    return ListView(
      padding: const EdgeInsets.fromLTRB(40, 16, 40, 100),
      children: [
        Text(
          context.tr('my_car_title'),
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontSize: 30),
        ),
        const SizedBox(height: 20),
        _vehicleChips(context, vehicles, true),
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
        if (context.watch<AppState>().activeServiceTicket != null) ...[
          const SizedBox(height: 18),
          _activeServiceCard(context, context.watch<AppState>().activeServiceTicket!),
        ],
        const SizedBox(height: 28),
        SectionHeader(title: context.tr('my_car_title')),
        const SizedBox(height: 16),
        QuickActionGrid(actions: _quickActions(context, vehicle)),
        const SizedBox(height: 28),
        SectionHeader(
          title: context.tr('qa_service_report'),
          actionLabel: context.tr('see_all'),
          onAction: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ServiceHistoryScreen(vehicle: vehicle),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _serviceHistoryCard(context, vehicle, true),
      ],
    );
  }

  void _showInfo(
    BuildContext context, {
    required List<List<dynamic>> icon,
    required String title,
    required String body,
  }) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 36),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.bmwBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: HugeIcon(
                  icon: icon,
                  color: AppColors.bmwBlue,
                  size: 28,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                body,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(context.tr('got_it')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
