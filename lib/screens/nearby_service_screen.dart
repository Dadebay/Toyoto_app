import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../l10n/strings.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_back_button.dart';
import '../widgets/app_card.dart';
import '../widgets/fake_map_background.dart';
import 'book_service_screen.dart';
import 'package:hugeicons/hugeicons.dart';

class NearbyServiceScreen extends StatelessWidget {
  const NearbyServiceScreen({super.key});

  static const _pinOffsets = [
    Offset(0.5, 0.55),
    Offset(0.72, 0.18),
    Offset(0.2, 0.2),
    Offset(0.82, 0.72),
    Offset(0.3, 0.8),
  ];

  @override
  Widget build(BuildContext context) {
    final dealers = MockData.dealers;
    final tablet = context.isTablet;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(context.tr('nearby_title')),
      ),
      body: Column(
        children: [
          SizedBox(
            height: tablet ? 240 : 180,
            child: FakeMapBackground(
              child: Stack(
                children: List.generate(dealers.length, (i) {
                  final offset = _pinOffsets[i % _pinOffsets.length];
                  return Align(
                    alignment: Alignment(offset.dx * 2 - 1, offset.dy * 2 - 1),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedLocation05,
                      color: i == 0 ? AppColors.bmwBlue : AppColors.black,
                      size: i == 0 ? (tablet ? 38 : 32) : (tablet ? 26 : 22),
                    ),
                  );
                }),
              ),
            ),
          ),
          Expanded(
            child: tablet
                ? GridView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: dealers.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.9,
                        ),
                    itemBuilder: (context, i) =>
                        _DealerTile(dealer: dealers[i], tablet: true),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: dealers.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, i) =>
                        _DealerTile(dealer: dealers[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _DealerTile extends StatelessWidget {
  final Dealer dealer;
  final bool tablet;

  const _DealerTile({required this.dealer, this.tablet = false});

  List<List<dynamic>> _serviceIcon(String s) {
    switch (s) {
      case 'showroom':
        return HugeIcons.strokeRoundedStore02;
      case 'parts':
        return HugeIcons.strokeRoundedSetting07;
      default:
        return HugeIcons.strokeRoundedWrench01;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dealer.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: tablet ? 17 : 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dealer.address,
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
                  color: AppColors.bmwBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${dealer.distanceKm.toStringAsFixed(1)} km',
                  style: TextStyle(
                    color: AppColors.bmwBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: tablet ? 13.5 : 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: dealer.services
                .map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: HugeIcon(
                      icon: _serviceIcon(s),
                      size: tablet ? 21 : 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedCall02,
                    size: tablet ? 18 : 16,
                  ),
                  label: Text(context.tr('call')),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: tablet ? 12 : 10),
                    textStyle: TextStyle(fontSize: tablet ? 14 : null),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BookServiceScreen(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: tablet ? 12 : 10),
                    textStyle: TextStyle(fontSize: tablet ? 14 : null),
                  ),
                  child: Text(context.tr('book_here')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
