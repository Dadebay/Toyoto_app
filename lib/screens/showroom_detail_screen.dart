import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../l10n/model_localization.dart';
import '../l10n/strings.dart';
import '../models/models.dart';
import '../services/sound_service.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/car_3d_viewer.dart';
import 'finance_calculator_screen.dart';
import 'test_drive_screen.dart';
import 'trade_in_screen.dart';
import 'package:hugeicons/hugeicons.dart';

class _PaintOption {
  final String label;
  final Color color;
  const _PaintOption(this.label, this.color);
}

const List<_PaintOption> _kPaintOptions = [
  _PaintOption('White', Color(0xFFF2F3F5)),
  _PaintOption('Silver', Color(0xFFC8CDD1)),
  _PaintOption('Gray', Color(0xFF54585C)),
  _PaintOption('Black', Color(0xFF0A0A0C)),
  _PaintOption('Red', AppColors.bmwBlue),
  _PaintOption('Blue', Color(0xFF1E3F73)),
];

class ShowroomDetailScreen extends StatefulWidget {
  final NewCarListing listing;

  const ShowroomDetailScreen({super.key, required this.listing});

  @override
  State<ShowroomDetailScreen> createState() => _ShowroomDetailScreenState();
}

class _ShowroomDetailScreenState extends State<ShowroomDetailScreen> {
  late final Car3DViewerController _controller;
  int _colorIndex = 0;
  int _trimIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = Car3DViewerController(
      paintMaterialName: widget.listing.paintMaterialName,
    );
  }

  double get _computedPrice =>
      widget.listing.basePrice + widget.listing.trims[_trimIndex].priceDelta;

  void _pickColor(int index) {
    setState(() => _colorIndex = index);
    _controller.setPaintColor(_kPaintOptions[index].color);
    SoundService.instance.play(SoundEffect.tap, volume: .3);
    HapticFeedback.selectionClick();
  }

  void _requestQuote(BuildContext context) {
    SoundService.instance.play(SoundEffect.success);
    HapticFeedback.mediumImpact();
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
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedTick01,
                  color: AppColors.success,
                  size: 28,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                context.tr('showroom_quote_sent_title'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('showroom_quote_sent_body'),
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

  Widget _topBar(BuildContext context, AppLanguage lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft02,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              widget.listing.name(lang),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _viewer(double height) {
    return SizedBox(
      height: height,
      child: Car3DViewer(
        modelAsset: widget.listing.modelAsset,
        controller: _controller,
        paintMaterialName: widget.listing.paintMaterialName,
      ),
    );
  }

  Widget _colorSwatches(bool tablet) {
    final swatchSize = tablet ? 44.0 : 36.0;
    return SizedBox(
      height: swatchSize + 8,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: _kPaintOptions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final selected = i == _colorIndex;
          return GestureDetector(
            onTap: () => _pickColor(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: swatchSize,
              height: swatchSize,
              decoration: BoxDecoration(
                color: _kPaintOptions[i].color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? Colors.white : Colors.white.withValues(alpha: 0.2),
                  width: selected ? 3 : 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _trimChips(BuildContext context, AppLanguage lang) {
    final trims = widget.listing.trims;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(trims.length, (i) {
        final selected = i == _trimIndex;
        return GestureDetector(
          onTap: () {
            setState(() => _trimIndex = i);
            SoundService.instance.play(SoundEffect.tap, volume: .3);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.bmwBlue : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              trims[i].name(lang),
              style: TextStyle(
                color: selected ? Colors.white : Colors.white.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _priceAndSpecs(BuildContext context) {
    final listing = widget.listing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: ScaleTransition(scale: anim, child: child),
          ),
          child: Text(
            '\$${_computedPrice.toStringAsFixed(0)}',
            key: ValueKey(_computedPrice),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _specTile(
                context,
                HugeIcons.strokeRoundedEngine,
                context.tr('showroom_engine'),
                listing.engine(context.watch<AppState>().language),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _specTile(
                context,
                HugeIcons.strokeRoundedFuelStation,
                context.tr('showroom_fuel_consumption'),
                '${listing.fuelConsumption} L/100km',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _specTile(
                context,
                HugeIcons.strokeRoundedLuggage01,
                context.tr('showroom_trunk_capacity'),
                '${listing.trunkCapacityLiters} L',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _specTile(
    BuildContext context,
    List<List<dynamic>> icon,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          HugeIcon(icon: icon, color: Colors.white70, size: 18),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _featuresList(BuildContext context, AppLanguage lang) {
    final features = widget.listing.trims[_trimIndex].features(lang);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('showroom_features'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        ...features.map(
          (f) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedTick01,
                  color: AppColors.success,
                  size: 16,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    f,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _secondaryActionButton(
    BuildContext context, {
    required List<List<dynamic>> icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HugeIcon(icon: icon, color: Colors.white, size: 20),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _secondaryActions(BuildContext context) {
    return Row(
      children: [
        _secondaryActionButton(
          context,
          icon: HugeIcons.strokeRoundedSteering,
          label: context.tr('showroom_book_test_drive'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TestDriveScreen(car: widget.listing),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _secondaryActionButton(
          context,
          icon: HugeIcons.strokeRoundedCalculator,
          label: context.tr('showroom_calc_finance'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  FinanceCalculatorScreen(vehiclePrice: _computedPrice),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _secondaryActionButton(
          context,
          icon: HugeIcons.strokeRoundedExchange02,
          label: context.tr('showroom_trade_in'),
          onTap: () async {
            final result = await Navigator.push<double>(
              context,
              MaterialPageRoute(
                builder: (_) => TradeInScreen(returnToPrice: _computedPrice),
              ),
            );
            if (result != null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${context.tr('tradein_estimated_value')}: \$${result.toStringAsFixed(0)}',
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _quoteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _requestQuote(context),
        child: Text(context.tr('showroom_request_quote')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tablet = context.isTablet;
    final lang = context.watch<AppState>().language;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemOverlay.forDarkScreens,
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: SafeArea(
          child: Column(
            children: [
              _topBar(context, lang),
              Expanded(
                child: tablet
                    ? _buildTabletLayout(context, lang)
                    : _buildPhoneLayout(context, lang),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneLayout(BuildContext context, AppLanguage lang) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        _viewer(260),
        const SizedBox(height: 16),
        _colorSwatches(false),
        const SizedBox(height: 22),
        Text(
          context.tr('showroom_select_trim'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        _trimChips(context, lang),
        const SizedBox(height: 24),
        _priceAndSpecs(context),
        const SizedBox(height: 24),
        _featuresList(context, lang),
        const SizedBox(height: 22),
        _secondaryActions(context),
        const SizedBox(height: 22),
        _quoteButton(context),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, AppLanguage lang) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 8, 32, 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              children: [
                _viewer(440),
                const SizedBox(height: 20),
                _colorSwatches(true),
              ],
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            flex: 4,
            child: ListView(
              children: [
                Text(
                  context.tr('showroom_select_trim'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 12),
                _trimChips(context, lang),
                const SizedBox(height: 28),
                _priceAndSpecs(context),
                const SizedBox(height: 28),
                _featuresList(context, lang),
                const SizedBox(height: 26),
                _secondaryActions(context),
                const SizedBox(height: 26),
                _quoteButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
