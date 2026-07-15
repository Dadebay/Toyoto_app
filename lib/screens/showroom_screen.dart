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
import 'compare_screen.dart';
import 'showroom_detail_screen.dart';
import 'package:hugeicons/hugeicons.dart';

class ShowroomScreen extends StatefulWidget {
  const ShowroomScreen({super.key});

  @override
  State<ShowroomScreen> createState() => _ShowroomScreenState();
}

class _ShowroomScreenState extends State<ShowroomScreen> {
  int _selected = 0;
  // Only the listing(s) the user has actually picked get a live 3D
  // WebView mounted — rendering all cards' model-viewers at once (e.g. in a
  // grid) spawns one WKWebView per card and reliably crashes the iOS
  // Simulator's shared GPU process, so exactly one stays live at a time,
  // matching the same lazy pattern used by Home/My Car's vehicle cards.
  final Set<int> _loaded = {0};

  void _select(int index) {
    setState(() {
      _selected = index;
      _loaded.add(index);
    });
  }

  Widget _carChips(List<NewCarListing> listings, AppLanguage lang) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: listings.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final selected = i == _selected;
          return ChoiceChip(
            selected: selected,
            label: Text(listings[i].name(lang)),
            onSelected: (_) => _select(i),
            selectedColor: AppColors.bmwBlue,
            backgroundColor: AppColors.card,
            labelStyle: TextStyle(
              color: selected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: AppColors.divider),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tablet = context.isTablet;
    final listings = MockData.newCarListings;
    final lang = context.watch<AppState>().language;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(context.tr('showroom_title')),
        actions: [
          IconButton(
            icon: const HugeIcon(icon: HugeIcons.strokeRoundedGitCompare),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CompareScreen()),
            ),
            tooltip: context.tr('showroom_compare'),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          tablet ? 32 : 16,
          14,
          tablet ? 32 : 16,
          32,
        ),
        children: [
          _carChips(listings, lang),
          const SizedBox(height: 14),
          SizedBox(
            height: tablet ? 480 : 380,
            child: IndexedStack(
              index: _selected,
              children: List.generate(listings.length, (i) {
                if (!_loaded.contains(i)) return const SizedBox.shrink();
                return _ShowroomCard(listing: listings[i], tablet: tablet);
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShowroomCard extends StatelessWidget {
  final NewCarListing listing;
  final bool tablet;

  const _ShowroomCard({required this.listing, required this.tablet});

  String _bodyTypeLabel(BuildContext context) {
    switch (listing.bodyType) {
      case 'suv':
        return context.tr('showroom_body_suv');
      case 'minivan':
        return context.tr('showroom_body_minivan');
      default:
        return context.tr('showroom_body_sedan');
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<AppState>().language;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ShowroomDetailScreen(listing: listing),
        ),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(
          tablet ? 22 : 18,
          tablet ? 22 : 18,
          tablet ? 22 : 18,
          0,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.black, AppColors.charcoal],
          ),
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _bodyTypeLabel(context),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: tablet ? 12.5 : 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              listing.name(lang),
              style: TextStyle(
                color: Colors.white,
                fontSize: tablet ? 22 : 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              '${context.tr('showroom_from')} \$${listing.basePrice.toStringAsFixed(0)}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: tablet ? 15 : 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Car3DViewer(
                modelAsset: listing.modelAsset,
                autoRotate: true,
                cameraControls: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
