import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../l10n/strings.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_back_button.dart';
import 'package:hugeicons/hugeicons.dart';

const _svcStepKeys = [
  'svc_step_received',
  'svc_step_diagnosis',
  'svc_step_parts',
  'svc_step_wash',
  'svc_step_ready',
];

const _svcStepIcons = [
  HugeIcons.strokeRoundedCheckmarkCircle02,
  HugeIcons.strokeRoundedSearch01,
  HugeIcons.strokeRoundedWrench01,
  HugeIcons.strokeRoundedDroplet,
  HugeIcons.strokeRoundedSteering,
];

class ServiceTrackingScreen extends StatefulWidget {
  const ServiceTrackingScreen({super.key});

  @override
  State<ServiceTrackingScreen> createState() => _ServiceTrackingScreenState();
}

class _ServiceTrackingScreenState extends State<ServiceTrackingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 9), (_) {
      final appState = context.read<AppState>();
      appState.advanceServiceStep();
      if (appState.activeServiceTicket?.currentStep == 4) {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _summaryCard(ServiceTicket ticket, bool tablet) {
    final hour = ticket.estimatedReadyAt.hour.toString().padLeft(2, '0');
    final minute = ticket.estimatedReadyAt.minute.toString().padLeft(2, '0');
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(tablet ? 24 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.black, AppColors.charcoal],
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ticket.vehicle.model,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: tablet ? 22 : 19,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.tr('svc_estimated_ready'),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: tablet ? 13.5 : 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$hour:$minute',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: tablet ? 30 : 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeline(ServiceTicket ticket, bool tablet) {
    return Column(
      children: List.generate(_svcStepKeys.length, (i) {
        final isDone = i < ticket.currentStep;
        final isActive = i == ticket.currentStep;
        final isLast = i == _svcStepKeys.length - 1;
        final color = isDone
            ? AppColors.success
            : isActive
            ? AppColors.toyotaRed
            : AppColors.divider;

        Widget circle = Container(
          width: tablet ? 48 : 40,
          height: tablet ? 48 : 40,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: HugeIcon(
            icon: isDone ? HugeIcons.strokeRoundedTick01 : _svcStepIcons[i],
            color: Colors.white,
            size: tablet ? 22 : 18,
          ),
        );

        if (isActive) {
          circle = circle
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(
                begin: 1.0,
                end: 1.12,
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
              );
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  circle,
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: isDone ? AppColors.success : AppColors.divider,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 28, top: 8),
                  child: Text(
                    context.tr(_svcStepKeys[i]),
                    style: TextStyle(
                      fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                      fontSize: tablet ? 17 : 15,
                      color: isActive || isDone
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
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
    final ticket = context.watch<AppState>().activeServiceTicket;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(context.tr('svc_track_title')),
      ),
      body: ticket == null
          ? const SizedBox.shrink()
          : tablet
          ? _buildTabletLayout(ticket)
          : _buildPhoneLayout(ticket),
    );
  }

  Widget _buildPhoneLayout(ServiceTicket ticket) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        _summaryCard(ticket, false),
        const SizedBox(height: 28),
        _timeline(ticket, false),
      ],
    );
  }

  Widget _buildTabletLayout(ServiceTicket ticket) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 340, child: _summaryCard(ticket, true)),
          const SizedBox(width: 32),
          Expanded(
            child: SingleChildScrollView(child: _timeline(ticket, true)),
          ),
        ],
      ),
    );
  }
}
