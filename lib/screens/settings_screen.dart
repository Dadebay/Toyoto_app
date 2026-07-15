import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../l10n/strings.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_animated_switch.dart';
import '../widgets/app_back_button.dart';
import '../widgets/app_card.dart';
import '../widgets/section_header.dart';
import 'package:hugeicons/hugeicons.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget _languageCard(
    BuildContext context,
    AppState appState,
    bool tablet,
    EdgeInsets rowPadding,
    TextStyle rowTextStyle,
  ) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: AppLanguage.values.map((lang) {
          final selected = appState.language == lang;
          return InkWell(
            onTap: () => appState.setLanguage(lang),
            child: Padding(
              padding: rowPadding,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: tablet ? 40 : 32,
                      height: tablet ? 30 : 24,
                      color: AppColors.surface,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        lang.flagAsset,
                        width: tablet ? 40 : 32,
                        height: tablet ? 30 : 24,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Text(lang.label, style: rowTextStyle)),
                  if (selected)
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                      color: AppColors.bmwBlue,
                      size: tablet ? 26 : 24,
                    )
                  else
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedCircle,
                      color: AppColors.divider,
                      size: tablet ? 26 : 24,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _togglesCard(
    BuildContext context,
    AppState appState,
    bool tablet,
    EdgeInsets rowPadding,
    TextStyle rowTextStyle,
  ) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: rowPadding,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    context.tr('push_notifications'),
                    style: rowTextStyle,
                  ),
                ),
                AppAnimatedSwitch(
                  value: appState.pushNotificationsEnabled,
                  onChanged: appState.togglePushNotifications,
                  scale: tablet ? 1.2 : 1.0,
                ),
              ],
            ),
          ),
          const Divider(height: 1, indent: 16),
          Padding(
            padding: rowPadding,
            child: Row(
              children: [
                Expanded(
                  child: Text(context.tr('sound_effects'), style: rowTextStyle),
                ),
                AppAnimatedSwitch(
                  value: appState.soundEnabled,
                  onChanged: appState.toggleSound,
                  scale: tablet ? 1.2 : 1.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _aboutCard(BuildContext context, bool tablet, TextStyle rowTextStyle) {
    return AppCard(
      child: Row(
        children: [
          Text(context.tr('version'), style: rowTextStyle),
          const Spacer(),
          Text(
            '1.0.0',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: tablet ? 15 : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tablet = context.isTablet;
    final rowPadding = EdgeInsets.symmetric(
      horizontal: tablet ? 20 : 16,
      vertical: tablet ? 18 : 14,
    );
    final rowTextStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: tablet ? 16 : null,
    );

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(context.tr('settings_title')),
      ),
      body: tablet
          ? _buildTabletLayout(context, appState, rowPadding, rowTextStyle)
          : _buildPhoneLayout(context, appState, rowPadding, rowTextStyle),
    );
  }

  Widget _buildPhoneLayout(
    BuildContext context,
    AppState appState,
    EdgeInsets rowPadding,
    TextStyle rowTextStyle,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        SectionHeader(title: context.tr('language')),
        const SizedBox(height: 12),
        _languageCard(context, appState, false, rowPadding, rowTextStyle),
        const SizedBox(height: 26),
        SectionHeader(title: context.tr('settings_title')),
        const SizedBox(height: 12),
        _togglesCard(context, appState, false, rowPadding, rowTextStyle),
        const SizedBox(height: 26),
        SectionHeader(title: context.tr('about_app')),
        const SizedBox(height: 12),
        _aboutCard(context, false, rowTextStyle),
      ],
    );
  }

  /// iPad splits language selection into a left column and the toggles/about
  /// cards into a right column, instead of stacking everything in one
  /// centered phone-width column.
  Widget _buildTabletLayout(
    BuildContext context,
    AppState appState,
    EdgeInsets rowPadding,
    TextStyle rowTextStyle,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: context.tr('language')),
                  const SizedBox(height: 14),
                  _languageCard(
                    context,
                    appState,
                    true,
                    rowPadding,
                    rowTextStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: context.tr('settings_title')),
                  const SizedBox(height: 14),
                  _togglesCard(
                    context,
                    appState,
                    true,
                    rowPadding,
                    rowTextStyle,
                  ),
                  const SizedBox(height: 26),
                  SectionHeader(title: context.tr('about_app')),
                  const SizedBox(height: 14),
                  _aboutCard(context, true, rowTextStyle),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
