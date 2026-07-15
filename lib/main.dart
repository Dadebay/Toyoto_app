import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:bmw_connect/global_safe_area_wrapper.dart';

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
          return GlobalSafeAreaWrapper(child: child ?? const SizedBox.shrink());
        },
      ),
    );
  }
}
