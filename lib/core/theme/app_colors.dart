import 'package:flutter/material.dart';

enum AppColorPalette {
  emerald,   // Zümrüt Yeşil & Altın
  goldBlack, // Altın & Saf Siyah
  sapphire,  // Safir Mavi & Siyah
  ruby,      // Yakut Kırmızı & Siyah
  purple,    // Gece Moru & Altın
  turquoise, // Turkuaz & Gümüş
}

class AppColors {
  static Color getPrimary(AppColorPalette palette) {
    switch (palette) {
      case AppColorPalette.emerald:
        return const Color(0xFF0F5132);
      case AppColorPalette.goldBlack:
        return const Color(0xFFD4AF37);
      case AppColorPalette.sapphire:
        return const Color(0xFF1E3A8A);
      case AppColorPalette.ruby:
        return const Color(0xFF991B1B);
      case AppColorPalette.purple:
        return const Color(0xFF581C87);
      case AppColorPalette.turquoise:
        return const Color(0xFF0D9488);
    }
  }

  static Color getAccent(AppColorPalette palette) {
    switch (palette) {
      case AppColorPalette.emerald:
        return const Color(0xFF198754);
      case AppColorPalette.goldBlack:
        return const Color(0xFFFFD700);
      case AppColorPalette.sapphire:
        return const Color(0xFF3B82F6);
      case AppColorPalette.ruby:
        return const Color(0xFFEF4444);
      case AppColorPalette.purple:
        return const Color(0xFFA855F7);
      case AppColorPalette.turquoise:
        return const Color(0xFF14B8A6);
    }
  }

  static Color getSecondary(AppColorPalette palette) {
    switch (palette) {
      case AppColorPalette.emerald:
      case AppColorPalette.purple:
        return const Color(0xFFD4AF37);
      case AppColorPalette.goldBlack:
        return const Color(0xFFFFFFFF);
      case AppColorPalette.sapphire:
        return const Color(0xFF60A5FA);
      case AppColorPalette.ruby:
        return const Color(0xFFFCA5A5);
      case AppColorPalette.turquoise:
        return const Color(0xFF99F6E4);
    }
  }

  // Standard constants
  static const Color emeraldPrimary = Color(0xFF0F5132);
  static const Color emeraldAccent = Color(0xFF198754);
  static const Color emeraldDark = Color(0xFF0A3622);
  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color goldAccent = Color(0xFFFFD700);

  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Colors.white;

  static const Color darkBackground = Color(0xFF12181B);
  static const Color darkSurface = Color(0xFF1E262C);

  static const Color amoledBackground = Color(0xFF000000);
  static const Color amoledSurface = Color(0xFF0A0A0A);

  static const Color lightTextPrimary = Color(0xFF212529);
  static const Color lightTextSecondary = Color(0xFF6C757D);

  static const Color darkTextPrimary = Color(0xFFF8F9FA);
  static const Color darkTextSecondary = Color(0xFFA0AEC0);

  static const Color success = Color(0xFF2EC4B6);
  static const Color warning = Color(0xFFFF9F1C);
  static const Color danger = Color(0xFFE71D36);
  static const Color info = Color(0xFF3A86FF);
}
