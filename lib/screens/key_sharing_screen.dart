import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/strings.dart';
import '../models/models.dart';
import '../services/sound_service.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_back_button.dart';
import '../widgets/app_card.dart';
import '../widgets/section_header.dart';
import 'package:hugeicons/hugeicons.dart';

const _durationOptions = [
  ('1day', Duration(days: 1)),
  ('1week', Duration(days: 7)),
  ('1month', Duration(days: 30)),
];

class KeySharingScreen extends StatefulWidget {
  const KeySharingScreen({super.key});

  @override
  State<KeySharingScreen> createState() => _KeySharingScreenState();
}

class _KeySharingScreenState extends State<KeySharingScreen> {
  final _nameController = TextEditingController();
  int _durationIndex = 0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _grantKey(BuildContext context) {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final duration = _durationOptions[_durationIndex].$2;
    context.read<AppState>().shareKey(
      SharedKey(
        id: '${DateTime.now().microsecondsSinceEpoch}',
        holderName: name,
        grantedAt: DateTime.now(),
        expiresAt: DateTime.now().add(duration),
      ),
    );
    SoundService.instance.play(SoundEffect.success);
    _nameController.clear();
    setState(() => _durationIndex = 0);
  }

  Widget _grantForm(bool tablet) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('keyshare_card_title'),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: tablet ? 18 : 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr('keyshare_card_body'),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: context.tr('keyshare_recipient_name'),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.tr('keyshare_duration'),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(_durationOptions.length, (i) {
              final selected = i == _durationIndex;
              return GestureDetector(
                onTap: () => setState(() => _durationIndex = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.toyotaRed : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    context.tr('keyshare_duration_${_durationOptions[i].$1}'),
                    style: TextStyle(
                      color: selected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _grantKey(context),
              child: Text(context.tr('keyshare_grant')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _keyCard(BuildContext context, SharedKey key, bool tablet) {
    final remaining = key.expiresAt.difference(DateTime.now());
    final expiresLabel = remaining.isNegative
        ? '0d'
        : remaining.inDays > 0
        ? '${remaining.inDays}d'
        : '${remaining.inHours}h';

    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.toyotaRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedUserSharing,
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
                  key.holderName,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: tablet ? 15 : 13.5,
                  ),
                ),
                Text(
                  '${context.tr('keyshare_expires_in')}: $expiresLabel',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.read<AppState>().revokeKey(key.id),
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedDelete02,
              color: AppColors.toyotaRed,
              size: tablet ? 20 : 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _activeKeysList(BuildContext context, List<SharedKey> keys, bool tablet) {
    if (keys.isEmpty) {
      return AppCard(
        child: Text(
          context.tr('keyshare_no_active_keys'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return Column(
      children: keys
          .map(
            (k) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _keyCard(context, k, tablet),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tablet = context.isTablet;
    final keys = context.watch<AppState>().sharedKeys;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(context.tr('keyshare_title')),
      ),
      body: tablet
          ? _buildTabletLayout(context, keys)
          : _buildPhoneLayout(context, keys),
    );
  }

  Widget _buildPhoneLayout(BuildContext context, List<SharedKey> keys) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        _grantForm(false),
        const SizedBox(height: 26),
        SectionHeader(title: context.tr('keyshare_active_keys')),
        const SizedBox(height: 12),
        _activeKeysList(context, keys, false),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, List<SharedKey> keys) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 380, child: _grantForm(true)),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: context.tr('keyshare_active_keys')),
                const SizedBox(height: 14),
                _activeKeysList(context, keys, true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
