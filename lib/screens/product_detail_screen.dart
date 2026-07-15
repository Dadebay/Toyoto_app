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

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _qty = 1;

  Widget _buildImage(double height) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Image.asset(widget.product.imageAsset, fit: BoxFit.contain),
    );
  }

  List<Widget> _buildDetails(BuildContext context, bool tablet) {
    final appState = context.watch<AppState>();
    final lang = appState.language;
    final p = widget.product;
    return [
      Text(
        p.name(lang),
        style: TextStyle(
          fontSize: tablet ? 26 : 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        '\$${p.price.toStringAsFixed(0)}',
        style: TextStyle(
          fontSize: tablet ? 28 : 22,
          fontWeight: FontWeight.w800,
          color: AppColors.bmwBlue,
        ),
      ),
      SizedBox(height: tablet ? 22 : 18),
      Row(
        children: [
          Expanded(
            child: _SpecChip(
              icon: HugeIcons.strokeRoundedBarCode02,
              label: context.tr('oem_code'),
              value: p.oemCode,
              tablet: tablet,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SpecChip(
              icon: HugeIcons.strokeRoundedShieldUser,
              label: context.tr('warranty'),
              value: '${p.warrantyMonths} ${context.tr('months_short')}',
              tablet: tablet,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SpecChip(
              icon: HugeIcons.strokeRoundedPackage,
              label: context.tr('in_stock'),
              value: '${p.stockCount} ${context.tr('pieces_short')}',
              tablet: tablet,
            ),
          ),
        ],
      ),
      SizedBox(height: tablet ? 28 : 24),
      Text(
        context.tr('description'),
        style: TextStyle(
          fontSize: tablet ? 18 : 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        p.description(lang),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          height: 1.5,
          fontSize: tablet ? 15.5 : null,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final lang = appState.language;
    final p = widget.product;
    final tablet = context.isTablet;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(context.tr('product_details')),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: tablet ? 900 : double.infinity),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: tablet
                ? [
                    // iPad gets a side-by-side layout (image left, details
                    // right) instead of the phone's stacked layout, since
                    // there's enough width to show both at once.
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 340, child: _buildImage(340)),
                          const SizedBox(width: 28),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildDetails(context, tablet),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                : [
                    _buildImage(220),
                    const SizedBox(height: 20),
                    ..._buildDetails(context, tablet),
                  ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: tablet ? 900 : double.infinity,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.divider),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () =>
                              setState(() => _qty = (_qty - 1).clamp(1, 99)),
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedMinusSign,
                            size: tablet ? 22 : 18,
                          ),
                        ),
                        SizedBox(
                          width: tablet ? 28 : 22,
                          child: Text(
                            '$_qty',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: tablet ? 17 : null,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              setState(() => _qty = (_qty + 1).clamp(1, 99)),
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedPlusSign,
                            size: tablet ? 22 : 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        appState.addToCart(p, quantity: _qty);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${context.tr('added_to_cart')}: ${p.name(lang)} ×$_qty',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        setState(() => _qty = 1);
                      },
                      style: tablet
                          ? ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              textStyle: const TextStyle(fontSize: 16),
                            )
                          : null,
                      child: Text(context.tr('add_to_cart')),
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
}

class _SpecChip extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String label;
  final String value;
  final bool tablet;

  const _SpecChip({
    required this.icon,
    required this.label,
    required this.value,
    this.tablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: tablet ? 16 : 12,
        horizontal: tablet ? 10 : 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          HugeIcon(
            icon: icon,
            color: AppColors.bmwBlue,
            size: tablet ? 24 : 18,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: tablet ? 15 : 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: tablet ? 12.5 : 10,
            ),
          ),
        ],
      ),
    );
  }
}
