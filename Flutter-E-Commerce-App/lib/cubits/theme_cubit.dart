import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'theme_mode';

  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey) ?? false;
      emit(isDark ? ThemeMode.dark : ThemeMode.light);
    } catch (e) {
      // If there's an error (e.g., wrong type stored), clear it and use default
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_themeKey);
      emit(ThemeMode.light);
    }
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(newMode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, newMode == ThemeMode.dark);
  }

  bool get isDark => state == ThemeMode.dark;
}
