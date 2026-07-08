import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../l10n/strings.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_card.dart';
import '../widgets/section_header.dart';
import 'my_car_screen.dart';
import 'notifications_screen.dart';
import 'order_history_screen.dart';
import 'settings_screen.dart';
import 'package:hugeicons/hugeicons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: context.isTablet
          ? _buildTabletLayout(context)
          : _buildPhoneLayout(context),
    );
  }

  Widget _buildPhoneLayout(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        Text(
          context.tr('profile_title'),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 18),
        const _ProfileHeaderCard(),
        const SizedBox(height: 24),
        SectionHeader(title: context.tr('my_vehicles')),
        const SizedBox(height: 12),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _MenuTile(
                icon: HugeIcons.strokeRoundedCar05,
                iconColor: AppColors.toyotaRed,
                label: context.tr('my_vehicles'),
                trailingLabel: '${MockData.vehicles.length}',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyCarScreen()),
                ),
              ),
              const Divider(height: 1, indent: 68),
              _MenuTile(
                icon: HugeIcons.strokeRoundedInvoice03,
                iconColor: const Color(0xFF2B7DE9),
                label: context.tr('order_history_title'),
                trailingLabel: '${MockData.orders.length}',
                previewImages: MockData.orders
                    .map((o) => o.imageAsset)
                    .toList(),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SectionHeader(title: context.tr('settings_title')),
        const SizedBox(height: 12),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _MenuTile(
                icon: HugeIcons.strokeRoundedNotification01,
                iconColor: AppColors.warning,
                label: context.tr('notifications_title'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                ),
              ),
              const Divider(height: 1, indent: 68),
              _MenuTile(
                icon: HugeIcons.strokeRoundedSettings02,
                iconColor: AppColors.textSecondary,
                label: context.tr('settings_title'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AppCard(
          padding: EdgeInsets.zero,
          child: _MenuTile(
            icon: HugeIcons.strokeRoundedLogout03,
            iconColor: AppColors.toyotaRed,
            label: context.tr('logout'),
            labelColor: AppColors.toyotaRed,
            showChevron: false,
            onTap: () => _confirmLogout(context),
          ),
        ),
      ],
    );
  }

  /// iPad gets a real two-column layout — a fixed-width profile card on the
  /// left, and the menu sections laid out as 2-up card grids on the right —
  /// instead of a phone-width column floating in a sea of blank margin.
  Widget _buildTabletLayout(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(32, 20, 32, 100),
      children: [
        Text(
          context.tr('profile_title'),
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontSize: 32),
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 360,
              child: Column(
                children: [
                  const _ProfileHeaderCard(tablet: true),
                  const SizedBox(height: 20),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: _MenuTile(
                      icon: HugeIcons.strokeRoundedLogout03,
                      iconColor: AppColors.toyotaRed,
                      label: context.tr('logout'),
                      labelColor: AppColors.toyotaRed,
                      showChevron: false,
                      tablet: true,
                      onTap: () => _confirmLogout(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: context.tr('my_vehicles')),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppCard(
                          padding: EdgeInsets.zero,
                          child: _MenuTile(
                            icon: HugeIcons.strokeRoundedCar05,
                            iconColor: AppColors.toyotaRed,
                            label: context.tr('my_vehicles'),
                            trailingLabel: '${MockData.vehicles.length}',
                            tablet: true,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MyCarScreen(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppCard(
                          padding: EdgeInsets.zero,
                          child: _MenuTile(
                            icon: HugeIcons.strokeRoundedInvoice03,
                            iconColor: const Color(0xFF2B7DE9),
                            label: context.tr('order_history_title'),
                            trailingLabel: '${MockData.orders.length}',
                            previewImages: MockData.orders
                                .map((o) => o.imageAsset)
                                .toList(),
                            tablet: true,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OrderHistoryScreen(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SectionHeader(title: context.tr('settings_title')),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppCard(
                          padding: EdgeInsets.zero,
                          child: _MenuTile(
                            icon: HugeIcons.strokeRoundedNotification01,
                            iconColor: AppColors.warning,
                            label: context.tr('notifications_title'),
                            tablet: true,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotificationsScreen(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppCard(
                          padding: EdgeInsets.zero,
                          child: _MenuTile(
                            icon: HugeIcons.strokeRoundedSettings02,
                            iconColor: AppColors.textSecondary,
                            label: context.tr('settings_title'),
                            tablet: true,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SettingsScreen(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _confirmLogout(BuildContext context) {
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
                  decoration: BoxDecoration(
                    color: AppColors.toyotaRed.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedLogout03,
                    color: AppColors.toyotaRed,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  context.tr('logout'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.tr('logout_confirm_message'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.toyotaRed,
                    ),
                    child: Text(context.tr('logout')),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(context.tr('cancel')),
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

class _ProfileHeaderCard extends StatelessWidget {
  final bool tablet;

  const _ProfileHeaderCard({this.tablet = false});

  @override
  Widget build(BuildContext context) {
    final avatarSize = tablet ? 92.0 : 72.0;
    return Container(
      padding: EdgeInsets.all(tablet ? 26 : 20),
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
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: const BoxDecoration(
                      color: AppColors.toyotaRed,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'A',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: tablet ? 38 : 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.all(tablet ? 7 : 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.black, width: 2),
                      ),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedPencilEdit01,
                        color: AppColors.black,
                        size: tablet ? 16 : 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ahmet Nurmuhammedow',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: tablet ? 21 : 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+993 65 12 34 56',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: tablet ? 15 : 12.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: tablet ? 12 : 10,
                        vertical: tablet ? 5 : 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.toyotaRed.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.toyotaRed.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedAward01,
                            color: AppColors.toyotaRed,
                            size: tablet ? 14 : 12,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Premium Agza',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: tablet ? 13 : 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: tablet ? 26 : 20),
          Row(
            children: [
              Expanded(
                child: _statTile(
                  '${MockData.vehicles.length}',
                  context.tr('my_vehicles'),
                ),
              ),
              _divider(),
              Expanded(
                child: _statTile(
                  '${MockData.orders.length}',
                  context.tr('order_history_title'),
                ),
              ),
              _divider(),
              Expanded(
                child: _StatTileStatic(
                  value: '2024',
                  label: 'Agza',
                  tablet: tablet,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: tablet ? 40 : 32,
      color: Colors.white.withValues(alpha: 0.1),
    );
  }

  Widget _statTile(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: tablet ? 21 : 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.55),
            fontSize: tablet ? 13 : 10.5,
          ),
        ),
      ],
    );
  }
}

class _StatTileStatic extends StatelessWidget {
  final String value;
  final String label;
  final bool tablet;

  const _StatTileStatic({
    required this.value,
    required this.label,
    this.tablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: tablet ? 21 : 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.55),
            fontSize: tablet ? 13 : 10.5,
          ),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  final List<List<dynamic>> icon;
  final Color iconColor;
  final String label;
  final Color? labelColor;
  final String? trailingLabel;
  final bool showChevron;
  final List<String>? previewImages;
  final bool tablet;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.trailingLabel,
    this.showChevron = true,
    this.previewImages,
    this.tablet = false,
  });

  Widget _buildLeading() {
    final images = previewImages;
    final iconBoxSize = tablet ? 44.0 : 36.0;
    if (images == null || images.isEmpty) {
      return Container(
        padding: EdgeInsets.all(tablet ? 12 : 9),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(11),
        ),
        child: HugeIcon(icon: icon, color: iconColor, size: tablet ? 22 : 18),
      );
    }

    final shown = images.take(3).toList();
    return SizedBox(
      width: iconBoxSize + (shown.length - 1) * 14.0,
      height: iconBoxSize,
      child: Stack(
        children: List.generate(shown.length, (i) {
          return Positioned(
            left: i * 14.0,
            child: Container(
              width: iconBoxSize - 4,
              height: iconBoxSize - 4,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                border: Border.all(color: AppColors.card, width: 2),
              ),
              child: Image.asset(shown[i], fit: BoxFit.contain),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tablet ? 20 : 16,
          vertical: tablet ? 18 : 14,
        ),
        child: Row(
          children: [
            _buildLeading(),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: tablet ? 16 : null,
                  color: labelColor ?? AppColors.textPrimary,
                ),
              ),
            ),
            if (trailingLabel != null) ...[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: tablet ? 11 : 9,
                  vertical: tablet ? 4 : 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  trailingLabel!,
                  style: TextStyle(
                    fontSize: tablet ? 14 : 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (showChevron)
              HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                color: AppColors.textSecondary,
                size: tablet ? 22 : 18,
              ),
          ],
        ),
      ),
    );
  }
}
