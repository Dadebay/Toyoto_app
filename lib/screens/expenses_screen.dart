import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../l10n/strings.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_back_button.dart';
import '../widgets/app_card.dart';
import '../widgets/monthly_expense_bar_chart.dart';
import 'package:hugeicons/hugeicons.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  Widget _iconAmount(BuildContext context, List<List<dynamic>> icon, Color color, String label, double amount) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: HugeIcon(icon: icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${amount.toStringAsFixed(0)}',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(BuildContext context, bool tablet) {
    final expenses = MockData.monthlyExpenses;
    final thisMonth = expenses.last;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('expenses_this_month'),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${thisMonth.total.toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: tablet ? 32 : 26,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _iconAmount(context, HugeIcons.strokeRoundedFuelStation, AppColors.toyotaRed, context.tr('expenses_fuel'), thisMonth.fuelCost),
              _iconAmount(context, HugeIcons.strokeRoundedWrench01, AppColors.warning, context.tr('expenses_service'), thisMonth.serviceCost),
              _iconAmount(context, HugeIcons.strokeRoundedSettings02, const Color(0xFF2B7DE9), context.tr('expenses_parts'), thisMonth.partsCost),
            ],
          ),
        ],
      ),
    );
  }

  Widget _insightCard(BuildContext context) {
    final expenses = MockData.monthlyExpenses;
    if (expenses.length < 2) return const SizedBox.shrink();
    final current = expenses.last.total;
    final previous = expenses[expenses.length - 2].total;
    if (previous == 0) return const SizedBox.shrink();
    final diffPercent = ((current - previous) / previous * 100);
    final isLower = diffPercent < 0;
    final color = isLower ? AppColors.success : AppColors.warning;
    final key = isLower ? 'expenses_insight_lower' : 'expenses_insight_higher';
    final text = context.tr(key).replaceFirst('{n}', diffPercent.abs().round().toString());

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          HugeIcon(
            icon: isLower
                ? HugeIcons.strokeRoundedArrowDown01
                : HugeIcons.strokeRoundedArrowUp01,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend() {
    Widget dot(Color color, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
    return Builder(
      builder: (context) => Wrap(
        spacing: 16,
        children: [
          dot(AppColors.toyotaRed, context.tr('expenses_fuel')),
          dot(AppColors.warning, context.tr('expenses_service')),
          dot(const Color(0xFF2B7DE9), context.tr('expenses_parts')),
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
        title: Text(context.tr('expenses_title')),
      ),
      body: tablet ? _buildTabletLayout(context) : _buildPhoneLayout(context),
    );
  }

  Widget _buildPhoneLayout(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        _summaryCard(context, false),
        const SizedBox(height: 14),
        _insightCard(context),
        const SizedBox(height: 24),
        AppCard(
          child: Column(
            children: [
              MonthlyExpenseBarChart(data: MockData.monthlyExpenses),
              const SizedBox(height: 14),
              _legend(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 340,
            child: Column(
              children: [
                _summaryCard(context, true),
                const SizedBox(height: 16),
                _insightCard(context),
              ],
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: AppCard(
              child: Column(
                children: [
                  MonthlyExpenseBarChart(
                    data: MockData.monthlyExpenses,
                    height: 240,
                  ),
                  const SizedBox(height: 16),
                  _legend(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
