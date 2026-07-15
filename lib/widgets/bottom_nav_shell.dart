import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../l10n/strings.dart';
import '../screens/ai_assistant_screen.dart';
import '../screens/home_screen.dart';
import '../screens/my_car_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/store_screen.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'package:hugeicons/hugeicons.dart';

class BottomNavShell extends StatefulWidget {
  const BottomNavShell({super.key});

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    // Watch language so switching it rebuilds every tab screen below.
    context.watch<AppState>();

    final screens = [
      const HomeScreen(),
      const MyCarScreen(),
      const AiAssistantScreen(),
      const StoreScreen(),
      const ProfileScreen(),
    ];

    final items = [
      (HugeIcons.strokeRoundedHome01, context.tr('nav_home')),
      (HugeIcons.strokeRoundedCar01, context.tr('nav_car')),
      (HugeIcons.strokeRoundedRobot02, context.tr('nav_ai')),
      (HugeIcons.strokeRoundedStore01, context.tr('nav_store')),
      (HugeIcons.strokeRoundedUserCircle02, context.tr('nav_profile')),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemOverlay.forLightScreens,
      child: Scaffold(
        body: IndexedStack(index: _index, children: screens),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.card,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (i) {
                final selected = i == _index;
                final (icon, label) = items[i];
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _index = i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HugeIcon(
                          icon: icon,
                          color: selected
                              ? AppColors.bmwBlue
                              : AppColors.textSecondary,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: selected
                                ? AppColors.bmwBlue
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
