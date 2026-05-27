import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('vi')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('languageCode') ?? 'vi';
      state = Locale(languageCode);
    } catch (e) {
      debugPrint('Error loading locale: $e');
      state = const Locale('vi');
    }
  }

  Future<void> changeLocale(String languageCode) async {
    try {
      state = Locale(languageCode);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', languageCode);
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
