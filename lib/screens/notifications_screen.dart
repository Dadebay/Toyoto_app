import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/model_localization.dart';
import '../l10n/strings.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/app_back_button.dart';
import 'package:hugeicons/hugeicons.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  String _timeAgo(DateTime time, AppLanguage lang) {
    final diff = DateTime.now().difference(time);
    if (diff.inHours < 1) {
      return {
        AppLanguage.tk: '${diff.inMinutes} min öň',
        AppLanguage.en: '${diff.inMinutes}m ago',
        AppLanguage.ru: '${diff.inMinutes} мин назад',
      }[lang]!;
    }
    if (diff.inDays < 1) {
      return {
        AppLanguage.tk: '${diff.inHours} sagat öň',
        AppLanguage.en: '${diff.inHours}h ago',
        AppLanguage.ru: '${diff.inHours} ч назад',
      }[lang]!;
    }
    return {
      AppLanguage.tk: '${diff.inDays} gün öň',
      AppLanguage.en: '${diff.inDays}d ago',
      AppLanguage.ru: '${diff.inDays} дн назад',
    }[lang]!;
  }

  Widget _notificationTile(
    BuildContext context,
    AppNotification n,
    AppLanguage lang,
    bool tablet,
  ) {
    final unread = !n.read;
    return Container(
      // Shadow lives on the outer, unclipped box — putting it on the
      // same layer as the ClipRRect below would cut the blur off.
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: unread
                ? AppColors.toyotaRed.withValues(alpha: 0.045)
                : AppColors.card,
            border: Border.all(color: AppColors.divider),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left accent bar signals unread state without needing a
                // non-uniform (per-side-colored) border.
                Container(width: unread ? 3 : 0, color: AppColors.toyotaRed),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(tablet ? 20 : 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(tablet ? 14 : 10),
                          decoration: BoxDecoration(
                            color: unread
                                ? AppColors.toyotaRed.withValues(alpha: 0.12)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: HugeIcon(
                            icon: n.icon,
                            color: unread
                                ? AppColors.toyotaRed
                                : AppColors.textSecondary,
                            size: tablet ? 26 : 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                n.title(lang),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: tablet ? 17 : 14,
                                  color: unread
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                n.body(lang),
                                maxLines: tablet ? 3 : 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontSize: tablet ? 14.5 : null),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _timeAgo(n.time, lang),
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: tablet ? 13 : 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final lang = appState.language;
    final notifications = appState.notifications;
    final tablet = context.isTablet;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Text(context.tr('notifications_title')),
      ),
      body: tablet
          ? GridView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: notifications.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2.6,
              ),
              itemBuilder: (context, i) =>
                  _notificationTile(context, notifications[i], lang, true),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) =>
                  _notificationTile(context, notifications[i], lang, false),
            ),
    );
  }
}
