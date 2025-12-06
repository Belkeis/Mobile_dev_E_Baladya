import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial(const Locale('ar', ''))) {
    _loadLanguage();
  }

  static const String _languageKey = 'app_language';

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey) ?? 'ar';
      emit(LanguageChanged(Locale(languageCode, '')));
    } catch (e) {
      emit(LanguageChanged(const Locale('ar', '')));
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.languageCode);
      emit(LanguageChanged(locale));
    } catch (e) {
      // If saving fails, still emit the change
      emit(LanguageChanged(locale));
    }
  }

  void toggleLanguage() {
    final currentLocale = state.locale;
    final newLocale = currentLocale.languageCode == 'ar'
        ? const Locale('fr', '')
        : const Locale('ar', '');
    changeLanguage(newLocale);
  }
}

