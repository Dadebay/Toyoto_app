import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/model_localization.dart';
import '../l10n/strings.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_back_button.dart';
import '../widgets/qr_pattern_painter.dart';
import 'package:hugeicons/hugeicons.dart';

const _tierGradients = {
  'bronze': [Color(0xFF8D6E4B), Color(0xFF5C4630)],
  'silver': [Color(0xFFB0B4BA), Color(0xFF7C818A)],
  'gold': [AppColors.toyotaRed, AppColors.toyotaRedDark],
};

class LoyaltyScreen extends StatelessWidget {
  const LoyaltyScreen({super.key});

  double _tierProgress(int points, String tier) {
    if (tier == 'bronze') return (points / 1000).clamp(0, 1);
    if (tier == 'silver') return ((points - 1000) / 2000).clamp(0, 1);
    return 1.0;
  }

  Widget _membershipCard(BuildContext context, int points, String tier, bool tablet) {
    final gradient = _tierGradients[tier]!;
    return Container(
      padding: EdgeInsets.all(tablet ? 26 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('loyalty_member'),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: tablet ? 13 : 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ahmet Nurmuhammedow',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: tablet ? 20 : 17,
                  ),
                ),
                SizedBox(height: tablet ? 18 : 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedAward01,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        context.tr('loyalty_tier_$tier'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: QrPattern(size: tablet ? 64 : 52),
          ),
        ],
      ),
    );
  }

  Widget _balanceSection(BuildContext context, int points, String tier, bool tablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('loyalty_points_balance'),
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$points',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: tablet ? 40 : 32,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: _tierProgress(points, tier),
            minHeight: 8,
            backgroundColor: AppColors.divider,
            valueColor: const AlwaysStoppedAnimation(AppColors.toyotaRed),
          ),
        ),
      ],
    );
  }

  Widget _historyTile(BuildContext context, LoyaltyTransaction t, AppLanguage lang, bool tablet) {
    final positive = t.points >= 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(tablet ? 16 : 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(tablet ? 12 : 9),
            decoration: BoxDecoration(
              color: AppColors.toyotaRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: HugeIcon(
              icon: t.icon,
              color: AppColors.toyotaRed,
              size: tablet ? 22 : 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.description(lang),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: tablet ? 15 : 13,
                  ),
                ),
                Text(
                  '${t.date.day}.${t.date.month}.${t.date.year}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Text(
            '${positive ? '+' : ''}${t.points}',
            style: TextStyle(
              color: positive ? AppColors.success : AppColors.toyotaRed,
              fontWeight: FontWeight.w800,
              fontSize: tablet ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tablet = context.isTablet;
    final appState = context.watch<AppState>();
    final lang = appState.language;
    final points = appState.loyaltyPoints;
    final tier = appState.loyaltyTier;
    final history = appState.loyaltyTransactions;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(context.tr('loyalty_title')),
      ),
      body: tablet
          ? _buildTabletLayout(context, points, tier, lang, history)
          : _buildPhoneLayout(context, points, tier, lang, history),
    );
  }

  Widget _buildPhoneLayout(
    BuildContext context,
    int points,
    String tier,
    AppLanguage lang,
    List<LoyaltyTransaction> history,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        _membershipCard(context, points, tier, false),
        const SizedBox(height: 20),
        _balanceSection(context, points, tier, false),
        const SizedBox(height: 24),
        Text(
          context.tr('loyalty_history'),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const SizedBox(height: 12),
        ...history.map((t) => _historyTile(context, t, lang, false)),
      ],
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    int points,
    String tier,
    AppLanguage lang,
    List<LoyaltyTransaction> history,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 380,
            child: Column(
              children: [
                _membershipCard(context, points, tier, true),
                const SizedBox(height: 24),
                _balanceSection(context, points, tier, true),
              ],
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('loyalty_history'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 14),
                ...history.map((t) => _historyTile(context, t, lang, true)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
