import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../l10n/model_localization.dart';
import '../l10n/strings.dart';
import '../models/models.dart';
import '../services/sound_service.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_back_button.dart';
import '../widgets/app_card.dart';
import 'package:hugeicons/hugeicons.dart';

class ServiceHistoryScreen extends StatefulWidget {
  final Vehicle vehicle;

  const ServiceHistoryScreen({super.key, required this.vehicle});

  @override
  State<ServiceHistoryScreen> createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {
  bool _shared = false;

  void _sharePdf() {
    setState(() => _shared = true);
    SoundService.instance.play(SoundEffect.success);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('svc_history_share_success'))),
    );
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _shared = false);
    });
  }

  Widget _warrantyCard(bool tablet) {
    final mileageKm = widget.vehicle.mileageKm;
    final kmRemaining = (100000 - mileageKm).clamp(0, 100000);
    final kmFraction = (kmRemaining / 100000).clamp(0.0, 1.0);
    final assumedYearsUsed = (mileageKm / 15000).clamp(0.0, 3.0);
    final yearsRemaining = (3 - assumedYearsUsed).clamp(0.0, 3.0);
    final timeFraction = (yearsRemaining / 3).clamp(0.0, 1.0);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('svc_history_warranty_title'),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: tablet ? 17 : 15,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${context.tr('svc_history_warranty_time')}: ${yearsRemaining.toStringAsFixed(1)} ${context.tr('tradein_year').toLowerCase()}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: timeFraction,
              minHeight: 8,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation(AppColors.toyotaRed),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${context.tr('svc_history_warranty_km')}: $kmRemaining km',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: kmFraction,
              minHeight: 8,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation(AppColors.success),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shareButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _sharePdf,
        icon: HugeIcon(
          icon: _shared
              ? HugeIcons.strokeRoundedTick01
              : HugeIcons.strokeRoundedShare08,
          color: AppColors.toyotaRed,
          size: 18,
        ).animate(target: _shared ? 1 : 0).scaleXY(begin: 1, end: 1.2, duration: const Duration(milliseconds: 200)),
        label: Text(context.tr('svc_history_share_pdf')),
      ),
    );
  }

  Widget _timelineList(AppLanguage lang, bool tablet) {
    final records = MockData.serviceHistory
        .where((r) => r.vehicle == widget.vehicle)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    if (records.isEmpty) {
      return AppCard(
        child: Text(
          context.tr('svc_history_empty'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return Column(
      children: List.generate(records.length, (i) {
        final r = records[i];
        final isLast = i == records.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.toyotaRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(width: 2, color: AppColors.divider),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 22),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                r.description(lang),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: tablet ? 16 : 14,
                                ),
                              ),
                            ),
                            Text(
                              r.cost == 0
                                  ? context.tr('completed')
                                  : '\$${r.cost.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: AppColors.toyotaRed,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${r.date.day}.${r.date.month}.${r.date.year} · ${r.mileageKm} km · ${r.dealerName}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tablet = context.isTablet;
    final lang = context.watch<AppState>().language;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(context.tr('svc_history_title')),
      ),
      body: tablet
          ? _buildTabletLayout(lang)
          : _buildPhoneLayout(lang),
    );
  }

  Widget _buildPhoneLayout(AppLanguage lang) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        _warrantyCard(false),
        const SizedBox(height: 14),
        _shareButton(),
        const SizedBox(height: 26),
        _timelineList(lang, false),
      ],
    );
  }

  Widget _buildTabletLayout(AppLanguage lang) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 360,
            child: Column(
              children: [_warrantyCard(true), const SizedBox(height: 16), _shareButton()],
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: SingleChildScrollView(child: _timelineList(lang, true)),
          ),
        ],
      ),
    );
  }
}
