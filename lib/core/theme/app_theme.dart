import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData getLightTheme(AppColorPalette palette) {
    final primary = AppColors.getPrimary(palette);
    final accent = AppColors.getAccent(palette);
    final secondary = AppColors.getSecondary(palette);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: secondary,
        tertiary: accent,
        surface: AppColors.lightSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: AppColors.lightTextPrimary,
      ),
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: AppColors.lightTextPrimary,
        displayColor: AppColors.lightTextPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
        titleTextStyle: TextStyle(
          color: primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primary.withValues(alpha: 0.1),
        selectedColor: primary,
        labelStyle: TextStyle(color: AppColors.lightTextPrimary),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return Colors.grey.shade400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary.withValues(alpha: 0.3);
          return Colors.grey.shade200;
        }),
      ),
    );
  }

  static ThemeData getDarkTheme(AppColorPalette palette) {
    final primary = AppColors.getPrimary(palette);
    final accent = AppColors.getAccent(palette);
    final secondary = AppColors.getSecondary(palette);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: accent,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme.dark(
        primary: accent,
        secondary: secondary,
        tertiary: primary,
        surface: AppColors.darkSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: AppColors.darkTextPrimary,
      ),
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: AppColors.darkTextPrimary,
        displayColor: AppColors.darkTextPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: secondary),
        titleTextStyle: TextStyle(
          color: secondary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.black,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: accent.withValues(alpha: 0.15),
        selectedColor: accent,
        labelStyle: TextStyle(color: AppColors.darkTextPrimary),
        secondaryLabelStyle: const TextStyle(color: Colors.black),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return accent;
          return Colors.grey.shade600;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return accent.withValues(alpha: 0.3);
          return Colors.grey.shade800;
        }),
      ),
    );
  }

  static ThemeData getAmoledTheme(AppColorPalette palette) {
    final secondary = AppColors.getSecondary(palette);
    final accent = AppColors.getAccent(palette);
    final primary = AppColors.getPrimary(palette);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: secondary,
      scaffoldBackgroundColor: AppColors.amoledBackground,
      colorScheme: ColorScheme.dark(
        primary: secondary,
        secondary: accent,
        tertiary: primary,
        surface: AppColors.amoledSurface,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: Colors.white,
      ),
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.amoledBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: secondary),
        titleTextStyle: TextStyle(
          color: secondary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.amoledSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: secondary.withValues(alpha: 0.3), width: 1),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondary,
        foregroundColor: Colors.black,
      ),
    );
  }
}
