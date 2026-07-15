import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../l10n/model_localization.dart';
import '../l10n/strings.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_back_button.dart';
import '../widgets/car_3d_viewer.dart';
import 'package:hugeicons/hugeicons.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  int _indexA = 0;
  int _indexB = 1;

  void _pickCar(bool isSlotA, AppLanguage lang) {
    final listings = MockData.newCarListings;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(listings.length, (i) {
            return ListTile(
              title: Text(listings[i].name(lang)),
              trailing: Text('\$${listings[i].basePrice.toStringAsFixed(0)}'),
              onTap: () {
                setState(() {
                  if (isSlotA) {
                    _indexA = i;
                  } else {
                    _indexB = i;
                  }
                });
                Navigator.pop(sheetContext);
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _carSlot(
    BuildContext context,
    NewCarListing car,
    bool isSlotA,
    AppLanguage lang,
    double height,
  ) {
    return GestureDetector(
      onTap: () => _pickCar(isSlotA, lang),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            SizedBox(
              height: height,
              child: Car3DViewer(
                modelAsset: car.modelAsset,
                autoRotate: true,
                cameraControls: false,
                paintMaterialName: car.paintMaterialName,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      car.name(lang),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowDown01,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _specRow(String label, String valueA, String valueB, int? better) {
    TextStyle valueStyle(int slot) => TextStyle(
      fontWeight: FontWeight.w700,
      color: better == slot ? AppColors.success : AppColors.textPrimary,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(valueA, textAlign: TextAlign.center, style: valueStyle(0)),
          ),
          Expanded(
            flex: 2,
            child: Text(valueB, textAlign: TextAlign.center, style: valueStyle(1)),
          ),
        ],
      ),
    );
  }

  Widget _specTable(BuildContext context, NewCarListing a, NewCarListing b, AppLanguage lang) {
    return Column(
      children: [
        _specRow(
          context.tr('compare_price'),
          '\$${a.basePrice.toStringAsFixed(0)}',
          '\$${b.basePrice.toStringAsFixed(0)}',
          a.basePrice == b.basePrice ? null : (a.basePrice < b.basePrice ? 0 : 1),
        ),
        const Divider(height: 1),
        _specRow(
          context.tr('showroom_engine'),
          a.engine(lang),
          b.engine(lang),
          null,
        ),
        const Divider(height: 1),
        _specRow(
          context.tr('showroom_fuel_consumption'),
          '${a.fuelConsumption} L/100km',
          '${b.fuelConsumption} L/100km',
          a.fuelConsumption == b.fuelConsumption
              ? null
              : (a.fuelConsumption < b.fuelConsumption ? 0 : 1),
        ),
        const Divider(height: 1),
        _specRow(
          context.tr('showroom_trunk_capacity'),
          '${a.trunkCapacityLiters} L',
          '${b.trunkCapacityLiters} L',
          a.trunkCapacityLiters == b.trunkCapacityLiters
              ? null
              : (a.trunkCapacityLiters > b.trunkCapacityLiters ? 0 : 1),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tablet = context.isTablet;
    final lang = context.watch<AppState>().language;
    final listings = MockData.newCarListings;
    final carA = listings[_indexA];
    final carB = listings[_indexB];

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(context.tr('compare_title')),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: tablet ? 900 : double.infinity),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _carSlot(context, carA, true, lang, tablet ? 220 : 150),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _carSlot(context, carB, false, lang, tablet ? 220 : 150),
                    ),
                  ],
                ),
                SizedBox(height: tablet ? 24 : 18),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: tablet ? 20 : 14,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(AppRadius.card),
                  ),
                  child: _specTable(context, carA, carB, lang),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
