import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  double iconScale = 2.0;
  double headingFontSize = 30.0;
  double iconNavScale = 10.0;
  ThemeMode _themeMode = ThemeMode.system;

  get getThemeMode => _themeMode;

  get getIconScale => iconScale;
  get getHeadingFontSize => headingFontSize;
  get getIconNavScale => iconNavScale;

  set setIconNavScale(double value) {
    iconNavScale = value;
    notifyListeners();
  }

  set setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  set setIconScale(double value) {
    iconScale = value;
    notifyListeners();
  }

  set setHeadingFontSize(double value) {
    headingFontSize = value;
    notifyListeners();
  }
}
