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
import '../widgets/app_card.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  Widget _orderTile(
    BuildContext context,
    Order o,
    AppLanguage lang,
    bool tablet,
  ) {
    final delivered = o.statusEn == 'Delivered';
    return AppCard(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: tablet ? 92 : 72,
              height: tablet ? 92 : 72,
              color: AppColors.surface,
              child: Image.asset(o.imageAsset, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  o.productName(lang),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: tablet ? 16 : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${o.date.day.toString().padLeft(2, '0')}.${o.date.month.toString().padLeft(2, '0')}.${o.date.year} · \$${o.price.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: tablet ? 14 : null,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: tablet ? 12 : 10,
              vertical: tablet ? 6 : 5,
            ),
            decoration: BoxDecoration(
              color: (delivered ? AppColors.success : AppColors.warning)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              o.status(lang),
              style: TextStyle(
                color: delivered ? AppColors.success : AppColors.warning,
                fontWeight: FontWeight.w700,
                fontSize: tablet ? 13 : 11.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<AppState>().language;
    final orders = MockData.orders;
    final tablet = context.isTablet;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(context.tr('order_history_title')),
      ),
      body: tablet
          ? GridView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: orders.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 3.0,
              ),
              itemBuilder: (context, i) =>
                  _orderTile(context, orders[i], lang, true),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) =>
                  _orderTile(context, orders[i], lang, false),
            ),
    );
  }
}
