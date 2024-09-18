import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  double iconScale = 2.0;
  double iconNavScale = 10.0;

  ThemeMode _themeMode = ThemeMode.system;

  get getIconScale => iconScale;
  get getIconNavScale => iconNavScale;

  ThemeMode get currentTheme {
    return _themeMode;
  }

  bool isDarkMode(BuildContext context) {
    // _isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final value = _themeMode == ThemeMode.dark;

    print(" ${Theme.of(context).brightness} here");

    return value;
  }

  set setIconNavScale(double value) {
    iconNavScale = value;
    notifyListeners();
  }

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;

    notifyListeners();
  }

  set setIconScale(double value) {
    iconScale = value;
    notifyListeners();
  }
}
