import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:bmw_connect/global_safe_area_wrapper.dart';

import 'l10n/strings.dart';
import 'services/sound_service.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'widgets/bottom_nav_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(AppSystemOverlay.forLightScreens);
  SoundService.instance.warmUp();
  runApp(const BmwConnectApp());
}

class BmwConnectApp extends StatelessWidget {
  const BmwConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'BMW Connect',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const BottomNavShell(),
        builder: (context, child) {
          return Column(
            children: [
              SafeArea(
                bottom: false,
                child: Material(
                  color: const Color(0xFF153A69),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Text(
                        context.tr('demo_notice'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GlobalSafeAreaWrapper(
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
