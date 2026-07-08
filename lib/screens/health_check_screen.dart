import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../l10n/strings.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_back_button.dart';
import '../widgets/app_card.dart';
import '../widgets/health_score_ring.dart';
import '../widgets/section_header.dart';
import 'package:hugeicons/hugeicons.dart';

String _statusKey(int score) {
  if (score >= 90) return 'status_excellent';
  if (score >= 75) return 'status_good';
  return 'status_attention';
}

Color _statusColor(int score) {
  if (score >= 90) return AppColors.success;
  if (score >= 75) return AppColors.warning;
  return AppColors.toyotaRed;
}

class HealthCheckScreen extends StatelessWidget {
  const HealthCheckScreen({super.key});

  Widget _scoreCard(BuildContext context, int overall, bool tablet) {
    final now = DateTime.now();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: tablet ? 36 : 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.black, AppColors.charcoal],
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        children: [
          HealthScoreRing(
            score: overall,
            size: tablet ? 180 : 140,
            textColor: Colors.white,
            trackColor: Colors.white.withValues(alpha: 0.12),
          ),
          const SizedBox(height: 16),
          Text(
            context.tr(_statusKey(overall)),
            style: TextStyle(
              color: _statusColor(overall),
              fontWeight: FontWeight.w800,
              fontSize: tablet ? 18 : 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${context.tr('last_scan')}: ${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: tablet ? 14 : 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricsCard(BuildContext context, List metrics, bool tablet) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: List.generate(metrics.length, (i) {
          final m = metrics[i];
          final isLast = i == metrics.length - 1;
          final color = _statusColor(m.score);
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(tablet ? 20 : 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(tablet ? 14 : 10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: HugeIcon(
                        icon: m.icon,
                        color: color,
                        size: tablet ? 26 : 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  context.tr(m.key),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: tablet ? 16 : 13.5,
                                  ),
                                ),
                              ),
                              Text(
                                '${m.score}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: color,
                                  fontSize: tablet ? 16 : 13.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: m.score / 100,
                              minHeight: tablet ? 8 : 6,
                              backgroundColor: AppColors.divider,
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            context.tr(_statusKey(m.score)),
                            style: TextStyle(
                              fontSize: tablet ? 13 : 11,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }),
      ),
    );
  }

  Widget _scanButton(BuildContext context, bool tablet) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${context.tr('run_new_scan')}...')),
          );
        },
        icon: const HugeIcon(icon: HugeIcons.strokeRoundedRefresh),
        label: Text(context.tr('run_new_scan')),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: tablet ? 20 : 16),
          textStyle: TextStyle(fontSize: tablet ? 16 : null),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(context.tr('health_title')),
      ),
      body: context.isTablet
          ? _buildTabletLayout(context)
          : _buildPhoneLayout(context),
    );
  }

  Widget _buildPhoneLayout(BuildContext context) {
    final metrics = MockData.healthMetrics;
    final overall = MockData.overallHealthScore;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        _scoreCard(context, overall, false),
        const SizedBox(height: 24),
        SectionHeader(title: context.tr('health_title')),
        const SizedBox(height: 14),
        _metricsCard(context, metrics, false),
        const SizedBox(height: 28),
        _scanButton(context, false),
      ],
    );
  }

  /// iPad puts the overall score in a fixed-width left column (with the
  /// rescan action right underneath it) and the metrics list in a wider
  /// right column, instead of stacking everything in one centered column.
  Widget _buildTabletLayout(BuildContext context) {
    final metrics = MockData.healthMetrics;
    final overall = MockData.overallHealthScore;

    return ListView(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 360,
              child: Column(
                children: [
                  _scoreCard(context, overall, true),
                  const SizedBox(height: 20),
                  _scanButton(context, true),
                ],
              ),
            ),
            const SizedBox(width: 28),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: context.tr('health_title')),
                  const SizedBox(height: 14),
                  _metricsCard(context, metrics, true),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
