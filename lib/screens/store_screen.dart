import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../l10n/model_localization.dart';
import '../l10n/strings.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_card.dart';
import 'cart_screen.dart';
import 'order_history_screen.dart';
import 'product_detail_screen.dart';
import 'showroom_screen.dart';
import 'package:hugeicons/hugeicons.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final products = MockData.products;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('store_title')),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedShoppingCart01,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
              ),
              if (appState.cartItemCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.bmwBlue,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${appState.cartItemCount}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const HugeIcon(icon: HugeIcons.strokeRoundedInvoice03),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          final tablet = context.isTablet;
          return GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(
              tablet ? 20 : 14,
              10,
              tablet ? 20 : 14,
              32,
            ),
            itemCount: products.length + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: tablet ? 4 : 2,
              mainAxisSpacing: tablet ? 20 : 16,
              crossAxisSpacing: tablet ? 18 : 14,
              childAspectRatio: tablet ? 0.78 : 0.9,
            ),
            itemBuilder: (context, i) {
              if (i == 0) {
                return _ShowroomBanner(tablet: tablet);
              }
              return _ProductCard(product: products[i - 1], tablet: tablet);
            },
          );
        },
      ),
    );
  }
}

class _ShowroomBanner extends StatelessWidget {
  final bool tablet;

  const _ShowroomBanner({required this.tablet});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ShowroomScreen()),
      ),
      child: Container(
        padding: EdgeInsets.all(tablet ? 18 : 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.bmwBlue, AppColors.bmwBlueDark],
          ),
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedCar05,
              color: Colors.white,
              size: tablet ? 30 : 24,
            ),
            Text(
              context.tr('showroom_title'),
              maxLines: 2,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: tablet ? 17 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Product product;
  final bool tablet;

  const _ProductCard({required this.product, this.tablet = false});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _pressed = false;
  bool _justAdded = false;

  void _addToCart(BuildContext context, AppState appState) {
    final lang = appState.language;
    appState.addToCart(widget.product);
    setState(() => _justAdded = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _justAdded = false);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${context.tr('added_to_cart')}: ${widget.product.name(lang)}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final lang = appState.language;
    final p = widget.product;
    final qtyInCart = appState.cart[p] ?? 0;
    final tablet = widget.tablet;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.card),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: p),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            width: double.infinity,
                            height: tablet ? 140 : 96,
                            color: AppColors.surface,
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              p.imageAsset,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        if (qtyInCart > 0)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.bmwBlue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '×$qtyInCart',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: tablet ? 12 : 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      p.name(lang),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: tablet ? 15 : 12.5,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${p.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.bmwBlue,
                    fontSize: tablet ? 18 : 15,
                  ),
                ),
                GestureDetector(
                  onTapDown: (_) => setState(() => _pressed = true),
                  onTapUp: (_) => setState(() => _pressed = false),
                  onTapCancel: () => setState(() => _pressed = false),
                  onTap: () => _addToCart(context, appState),
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 100),
                    scale: _pressed ? 0.88 : 1.0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: tablet ? 42 : 34,
                      height: tablet ? 42 : 34,
                      decoration: BoxDecoration(
                        color: _justAdded
                            ? AppColors.success
                            : AppColors.bmwBlue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                (_justAdded
                                        ? AppColors.success
                                        : AppColors.bmwBlue)
                                    .withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        child: HugeIcon(
                          key: ValueKey(_justAdded),
                          icon: _justAdded
                              ? HugeIcons.strokeRoundedTick01
                              : HugeIcons.strokeRoundedPlusSign,
                          color: Colors.white,
                          size: tablet ? 22 : 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
