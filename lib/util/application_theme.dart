import 'package:flutter/material.dart';

/// Used for switching the application between light and dark mode.
class ApplicationTheme with ChangeNotifier {
  bool _isDark = true;

  /// Retrieves the current theme setting
  ThemeMode currentTheme() => _isDark ? ThemeMode.dark : ThemeMode.light;

  /// Toggles the application theme between light and dark
  void swapTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
