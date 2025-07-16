import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences? _prefs;
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeNotifier() {
    _loadFromPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> _loadFromPrefs() async {
    await _initPrefs();
    _isDarkMode = _prefs!.getBool(key) ?? false;
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    await _initPrefs();
    _prefs!.setBool(key, _isDarkMode);
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveToPrefs();
    notifyListeners();
  }
}
