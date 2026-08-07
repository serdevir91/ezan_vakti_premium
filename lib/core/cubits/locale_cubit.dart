import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  static const String _localeCodeKey = 'pref_app_locale';

  LocaleCubit() : super(const Locale('tr')) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedCode = prefs.getString(_localeCodeKey);

    if (savedCode != null && savedCode.isNotEmpty) {
      emit(Locale(savedCode));
    } else {
      // Auto-detect device system language on first launch
      final String sysLang = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      if (['tr', 'en', 'ar', 'fa'].contains(sysLang)) {
        emit(Locale(sysLang));
      } else {
        emit(const Locale('en'));
      }
    }
  }

  Future<void> changeLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeCodeKey, languageCode);
    emit(Locale(languageCode));
  }

  bool get isRtl => state.languageCode == 'ar' || state.languageCode == 'fa';
}
