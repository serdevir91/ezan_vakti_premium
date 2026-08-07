import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';

class ThemeState {
  final ThemeMode themeMode;
  final bool isAmoled;
  final AppColorPalette palette;

  ThemeState({
    required this.themeMode,
    required this.isAmoled,
    required this.palette,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? isAmoled,
    AppColorPalette? palette,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isAmoled: isAmoled ?? this.isAmoled,
      palette: palette ?? this.palette,
    );
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeModeKey = 'pref_theme_mode';
  static const String _isAmoledKey = 'pref_is_amoled';
  static const String _paletteKey = 'pref_color_palette';

  ThemeCubit()
      : super(ThemeState(
          themeMode: ThemeMode.system,
          isAmoled: false,
          palette: AppColorPalette.emerald,
        )) {
    _loadThemeSettings();
  }

  Future<void> _loadThemeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? themeStr = prefs.getString(_themeModeKey);
    final bool amoled = prefs.getBool(_isAmoledKey) ?? false;
    final int paletteIndex = prefs.getInt(_paletteKey) ?? 0;

    ThemeMode mode = ThemeMode.system;
    if (themeStr == 'light') mode = ThemeMode.light;
    if (themeStr == 'dark') mode = ThemeMode.dark;

    AppColorPalette pal = AppColorPalette.values[paletteIndex % AppColorPalette.values.length];

    emit(ThemeState(themeMode: mode, isAmoled: amoled, palette: pal));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    String modeStr = 'system';
    if (mode == ThemeMode.light) modeStr = 'light';
    if (mode == ThemeMode.dark) modeStr = 'dark';
    await prefs.setString(_themeModeKey, modeStr);

    emit(state.copyWith(themeMode: mode));
  }

  Future<void> toggleAmoled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isAmoledKey, enabled);

    emit(state.copyWith(isAmoled: enabled));
  }

  Future<void> setPalette(AppColorPalette palette) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_paletteKey, palette.index);

    emit(state.copyWith(palette: palette));
  }
}
