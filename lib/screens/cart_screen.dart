import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/model_localization.dart';
import '../l10n/strings.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_back_button.dart';
import 'package:hugeicons/hugeicons.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Widget _buildCartTile(
    BuildContext context,
    AppState appState,
    AppLanguage lang,
    Product product,
    int qty,
    bool tablet,
  ) {
    return Container(
      padding: EdgeInsets.all(tablet ? 16 : 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: tablet ? 72 : 56,
              height: tablet ? 72 : 56,
              padding: const EdgeInsets.all(6),
              color: AppColors.surface,
              child: Image.asset(product.imageAsset, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name(lang),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: tablet ? 15 : 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: AppColors.toyotaRed,
                    fontWeight: FontWeight.w800,
                    fontSize: tablet ? 15 : 13,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => appState.removeFromCart(product),
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedMinusSign,
                  size: tablet ? 19 : 16,
                ),
              ),
              Text(
                '$qty',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: tablet ? 16 : null,
                ),
              ),
              IconButton(
                onPressed: () => appState.addToCart(product),
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedPlusSign,
                  size: tablet ? 19 : 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final lang = appState.language;
    final entries = appState.cart.entries.toList();
    final tablet = context.isTablet;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(context.tr('cart_title')),
      ),
      body: entries.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedShoppingCart01,
                    color: AppColors.textSecondary,
                    size: tablet ? 64 : 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.tr('cart_empty'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: tablet ? 15 : null,
                    ),
                  ),
                ],
              ),
            )
          : tablet
          ? GridView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: entries.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 3.2,
              ),
              itemBuilder: (context, i) {
                final product = entries[i].key;
                final qty = entries[i].value;
                return _buildCartTile(
                  context,
                  appState,
                  lang,
                  product,
                  qty,
                  true,
                );
              },
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: entries.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final product = entries[i].key;
                final qty = entries[i].value;
                return _buildCartTile(
                  context,
                  appState,
                  lang,
                  product,
                  qty,
                  false,
                );
              },
            ),
      bottomNavigationBar: entries.isEmpty
          ? null
          : SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: tablet ? 900 : double.infinity,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.tr('total'),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                                fontSize: tablet ? 16 : null,
                              ),
                            ),
                            Text(
                              '\$${appState.cartTotal.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: tablet ? 22 : 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.toyotaRed,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _placeOrder(context, appState),
                            style: tablet
                                ? ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                    textStyle: const TextStyle(fontSize: 16),
                                  )
                                : null,
                            child: Text(context.tr('place_order')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void _placeOrder(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 36),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
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
                    color: AppColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                    color: AppColors.success,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  context.tr('order_placed_title'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.tr('order_placed_message'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      appState.clearCart();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(context.tr('got_it')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
