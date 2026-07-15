import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_back_button.dart';
import '../widgets/finance_ring_chart.dart';

class FinanceCalculatorScreen extends StatefulWidget {
  final double vehiclePrice;

  const FinanceCalculatorScreen({super.key, required this.vehiclePrice});

  @override
  State<FinanceCalculatorScreen> createState() =>
      _FinanceCalculatorScreenState();
}

class _FinanceCalculatorScreenState extends State<FinanceCalculatorScreen> {
  static const _flatAnnualRate = 0.14;
  static const _termOptions = [12, 24, 36, 48];

  double _downPaymentPercent = 0.2;
  int _termMonths = 36;

  double get _downPaymentAmount => widget.vehiclePrice * _downPaymentPercent;
  double get _principal => widget.vehiclePrice - _downPaymentAmount;
  double get _totalInterest =>
      _principal * _flatAnnualRate * (_termMonths / 12);
  double get _totalPayment => _principal + _totalInterest;
  double get _monthlyPayment =>
      _termMonths == 0 ? 0 : _totalPayment / _termMonths;

  String _money(double v) => '\$${v.toStringAsFixed(0)}';

  Widget _monthlyPaymentDisplay(bool tablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          context.tr('finance_monthly_payment'),
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: ScaleTransition(scale: anim, child: child),
          ),
          child: Text(
            _money(_monthlyPayment),
            key: ValueKey(_monthlyPayment),
            style: TextStyle(
              color: AppColors.bmwBlue,
              fontWeight: FontWeight.w800,
              fontSize: tablet ? 46 : 38,
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputsColumn(bool tablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('finance_vehicle_price'),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          _money(widget.vehiclePrice),
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: tablet ? 24 : 20,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          context.tr('finance_down_payment'),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          '${(_downPaymentPercent * 100).round()}% · ${_money(_downPaymentAmount)}',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        Slider(
          value: _downPaymentPercent,
          min: 0,
          max: 0.5,
          divisions: 50,
          activeColor: AppColors.bmwBlue,
          onChanged: (v) => setState(() => _downPaymentPercent = v),
        ),
        const SizedBox(height: 12),
        Text(
          context.tr('finance_term'),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _termOptions.map((months) {
            final selected = months == _termMonths;
            return GestureDetector(
              onTap: () => setState(() => _termMonths = months),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppColors.bmwBlue : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$months ${context.tr('finance_months_suffix')}',
                  style: TextStyle(
                    color: selected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _breakdown(bool tablet) {
    return Column(
      children: [
        FinanceRingChart(
          principal: _principal,
          interest: _totalInterest,
          size: tablet ? 160 : 130,
        ),
        const SizedBox(height: 20),
        _breakdownRow(context.tr('finance_principal'), _principal, AppColors.bmwBlue),
        _breakdownRow(context.tr('finance_total_interest'), _totalInterest, AppColors.warning),
        const Divider(height: 24),
        _breakdownRow(context.tr('finance_total_payment'), _totalPayment, AppColors.textPrimary, bold: true),
      ],
    );
  }

  Widget _breakdownRow(String label, double value, Color dotColor, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(label)),
          Text(
            _money(value),
            style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w600),
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
        title: Text(context.tr('finance_title')),
      ),
      body: tablet ? _buildTabletLayout() : _buildPhoneLayout(),
    );
  }

  Widget _buildPhoneLayout() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        _monthlyPaymentDisplay(false),
        const SizedBox(height: 28),
        _inputsColumn(false),
        const SizedBox(height: 28),
        _breakdown(false),
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _monthlyPaymentDisplay(true),
                  const SizedBox(height: 32),
                  _breakdown(true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
