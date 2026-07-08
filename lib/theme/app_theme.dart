import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  AppColors._();

  static const Color toyotaRed = Color(0xFFEB0A1E);
  static const Color toyotaRedDark = Color(0xFFB4000F);
  static const Color black = Color(0xFF0B0B0C);
  static const Color charcoal = Color(0xFF1B1C1F);
  static const Color surface = Color(0xFFF5F5F7);
  static const Color card = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF161616);
  static const Color textSecondary = Color(0xFF7A7A80);
  static const Color divider = Color(0xFFE7E7EB);
  static const Color success = Color(0xFF1FAA59);
  static const Color warning = Color(0xFFE8A33D);
}

/// [SystemUiOverlayStyle.light]/[.dark] only control the status bar; the
/// Android system navigation bar's icon color is a separate field that those
/// presets leave at a mismatched default, so we define our own here.
class AppSystemOverlay {
  AppSystemOverlay._();

  static const SystemUiOverlayStyle forLightScreens = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.card,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
  );

  static const SystemUiOverlayStyle forDarkScreens = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.black,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: Colors.transparent,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.card,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.toyotaRed,
        primary: AppColors.toyotaRed,
        brightness: Brightness.light,
      ),
      fontFamily: 'Gilroy',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        centerTitle: false,
        systemOverlayStyle: AppSystemOverlay.forLightScreens,
        titleTextStyle: TextStyle(
          fontFamily: 'Gilroy',
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
          height: 1.4,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.toyotaRed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          elevation: 0,
        ),
      ),
      dividerColor: AppColors.divider,
    );
  }
}

class AppRadius {
  AppRadius._();
  static const double card = 20;
  static const double chip = 14;
  static const double button = 14;
}
