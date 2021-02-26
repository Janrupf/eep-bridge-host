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

  static ThemeData dark() {
    return _applyCommonProperties(ThemeData.dark()).copyWith(
        accentColor: Color(0xFF060D1C),
        hintColor: Color(0x88FFFFFF),
        highlightColor: Color(0xFFFFFFFF));
  }

  static ThemeData light() {
    return _applyCommonProperties(ThemeData.light());
  }

  static ThemeData _applyCommonProperties(ThemeData data) {
    return data.copyWith(
        textTheme: data.textTheme.apply(fontFamily: "Roboto").copyWith(
            headline3: (data.textTheme.headline3 ?? TextStyle())
                .copyWith(fontSize: 30),
            headline6: (data.textTheme.headline6 ?? TextStyle())
                .copyWith(fontSize: 20, letterSpacing: 3)),
        primaryTextTheme: data.textTheme.apply(fontFamily: "Roboto"),
        accentTextTheme: data.textTheme.apply(fontFamily: "Roboto"));
  }
}
