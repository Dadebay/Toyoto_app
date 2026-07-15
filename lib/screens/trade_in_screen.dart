import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../l10n/strings.dart';
import '../models/models.dart';
import '../services/sound_service.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_back_button.dart';

int _estimateYearFromVehicle(Vehicle v) {
  final match = RegExp(r'(20\d{2})').firstMatch(v.model);
  if (match != null) return int.parse(match.group(1)!);
  const assumedAnnualKm = 15000;
  final age = (v.mileageKm / assumedAnnualKm).round().clamp(0, 15);
  return DateTime.now().year - age;
}

class _CountUpValue extends StatelessWidget {
  final double value;
  final TextStyle? style;

  const _CountUpValue({required this.value, this.style});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(value),
      tween: Tween(begin: 0, end: value),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => Text('\$${v.toStringAsFixed(0)}', style: style),
    );
  }
}

class TradeInScreen extends StatefulWidget {
  final double? returnToPrice;

  const TradeInScreen({super.key, this.returnToPrice});

  @override
  State<TradeInScreen> createState() => _TradeInScreenState();
}

class _TradeInScreenState extends State<TradeInScreen> {
  bool _manualEntry = false;
  int _vehicleIndex = 0;
  final _modelController = TextEditingController();
  final _yearController = TextEditingController(
    text: '${DateTime.now().year - 3}',
  );
  final _mileageController = TextEditingController(text: '50000');
  String _condition = 'good';
  double? _estimatedValue;

  @override
  void dispose() {
    _modelController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  void _estimate() {
    String model;
    int year;
    int mileage;
    if (_manualEntry) {
      model = _modelController.text.trim();
      year = int.tryParse(_yearController.text) ?? DateTime.now().year - 3;
      mileage = int.tryParse(_mileageController.text) ?? 50000;
    } else {
      final v = MockData.vehicles[_vehicleIndex];
      model = v.model;
      year = _estimateYearFromVehicle(v);
      mileage = v.mileageKm;
    }
    setState(() {
      _estimatedValue = MockData.estimateTradeInValue(
        model: model,
        year: year,
        mileageKm: mileage,
        condition: _condition,
      );
    });
    SoundService.instance.play(SoundEffect.success);
  }

  Widget _segmentedToggle(bool tablet) {
    Widget seg(String label, bool selected, VoidCallback onTap) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.toyotaRed : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: tablet ? 15 : 13,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          seg(
            context.tr('tradein_pick_vehicle'),
            !_manualEntry,
            () => setState(() => _manualEntry = false),
          ),
          seg(
            context.tr('tradein_manual_entry'),
            _manualEntry,
            () => setState(() => _manualEntry = true),
          ),
        ],
      ),
    );
  }

  Widget _vehiclePicker() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(MockData.vehicles.length, (i) {
        final selected = i == _vehicleIndex;
        return ChoiceChip(
          selected: selected,
          label: Text(MockData.vehicles[i].model),
          selectedColor: AppColors.toyotaRed,
          backgroundColor: AppColors.card,
          labelStyle: TextStyle(
            color: selected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.divider),
          ),
          onSelected: (_) => setState(() => _vehicleIndex = i),
        );
      }),
    );
  }

  Widget _manualForm() {
    return Column(
      children: [
        TextField(
          controller: _modelController,
          decoration: InputDecoration(labelText: context.tr('tradein_model')),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _yearController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: context.tr('tradein_year')),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _mileageController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: context.tr('tradein_mileage')),
        ),
      ],
    );
  }

  Widget _conditionChips() {
    const conditions = ['excellent', 'good', 'fair'];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: conditions.map((c) {
        final selected = c == _condition;
        return GestureDetector(
          onTap: () => setState(() => _condition = c),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.toyotaRed : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              context.tr('tradein_condition_$c'),
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _inputsColumn(bool tablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _segmentedToggle(tablet),
        const SizedBox(height: 20),
        _manualEntry ? _manualForm() : _vehiclePicker(),
        const SizedBox(height: 20),
        Text(
          context.tr('tradein_condition'),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        _conditionChips(),
        const SizedBox(height: 26),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _estimate,
            child: Text(context.tr('tradein_estimate_button')),
          ),
        ),
      ],
    );
  }

  Widget _resultCard(bool tablet) {
    final value = _estimatedValue;
    if (value == null) return const SizedBox.shrink();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(tablet ? 28 : 22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.black, AppColors.charcoal],
            ),
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Column(
            children: [
              Text(
                context.tr('tradein_estimated_value'),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _CountUpValue(
                value: value,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: tablet ? 40 : 32,
                ),
              ),
            ],
          ),
        ),
        if (widget.returnToPrice != null) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr('tradein_price_after_tradein'),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  '\$${(widget.returnToPrice! - value).clamp(0, widget.returnToPrice!).toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.toyotaRed,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, value),
              child: Text(context.tr('tradein_apply_to_showroom')),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tablet = context.isTablet;
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(context.tr('tradein_title')),
      ),
      body: tablet ? _buildTabletLayout() : _buildPhoneLayout(),
    );
  }

  Widget _buildPhoneLayout() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        _inputsColumn(false),
        const SizedBox(height: 26),
        _resultCard(false),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: SingleChildScrollView(child: _inputsColumn(true))),
          const SizedBox(width: 32),
          Expanded(child: SingleChildScrollView(child: _resultCard(true))),
        ],
      ),
    );
  }
}
