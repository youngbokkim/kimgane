import 'package:flutter/material.dart';

class AppColors {
  static const ink = Color(0xFF1C1410);
  static const inkMuted = Color(0xFF5C5348);
  static const hanji = Color(0xFFF4EFE4);
  static const hanjiCard = Color(0xFFFFFBF3);
  static const hanjiDark = Color(0xFFE4D8C0);
  static const line = Color(0xFFD7CBB3);
  static const cinnabar = Color(0xFF7A1F1F);
  static const cinnabarSoft = Color(0xFFB54A3C);
  static const indigo = Color(0xFF2C3A4F);
  static const gold = Color(0xFFC4A35A);
  static const pine = Color(0xFF3D5A45);
}

class AppTheme {
  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.cinnabar,
      onPrimary: Colors.white,
      secondary: AppColors.indigo,
      onSecondary: Colors.white,
      tertiary: AppColors.gold,
      onTertiary: AppColors.ink,
      error: Color(0xFFB3261E),
      onError: Colors.white,
      surface: AppColors.hanji,
      onSurface: AppColors.ink,
      outline: AppColors.line,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.hanji,
      fontFamily: 'NanumGothic',
      fontFamilyFallback: const ['NotoSerifKR'],
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.hanji,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'NanumMyeongjo',
          fontFamilyFallback: ['NotoSerifKR'],
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.hanjiCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.hanjiDark,
        selectedColor: AppColors.cinnabar.withValues(alpha: 0.12),
        labelStyle: const TextStyle(fontFamily: 'NanumGothic', fontSize: 13),
        side: const BorderSide(color: AppColors.line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.cinnabar,
        foregroundColor: Colors.white,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AppColors.hanjiCard,
        indicatorColor: Color(0x33B54A3C),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontFamily: 'NanumGothic', fontSize: 12),
        ),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: AppColors.hanjiCard,
        indicatorColor: Color(0x33B54A3C),
        selectedIconTheme: IconThemeData(color: AppColors.cinnabar),
        selectedLabelTextStyle: TextStyle(
          fontFamily: 'NanumGothic',
          color: AppColors.cinnabar,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.hanjiCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cinnabar, width: 1.4),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.line),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'NanumMyeongjo',
          fontFamilyFallback: ['NotoSerifKR'],
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'NanumMyeongjo',
          fontFamilyFallback: ['NotoSerifKR'],
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        titleLarge: TextStyle(
          fontFamily: 'NanumMyeongjo',
          fontFamilyFallback: ['NotoSerifKR'],
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        titleMedium: TextStyle(
          fontFamily: 'NanumGothic',
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        bodyLarge: TextStyle(fontFamily: 'NanumGothic', color: AppColors.ink),
        bodyMedium: TextStyle(
          fontFamily: 'NanumGothic',
          color: AppColors.ink,
          height: 1.55,
        ),
      ),
    );
  }
}
