import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  Color primaryColor = const Color.fromARGB(255, 30, 29, 29);
  Color secondaryColor = const Color.fromARGB(255, 93, 115, 126);
  Color accentColor = const Color.fromARGB(255, 255, 240, 124);
  Color accentColorWithOpacity = const Color.fromARGB(6, 255, 240, 124);

  double iconScale = 2.0;
  double headingFontSize = 30.0;
  double iconNavScale = 10.0;

  get getPrimaryColor => primaryColor;
  get getSecondaryColor => secondaryColor;
  get getAccentColor => accentColor;
  get getIconScale => iconScale;
  get getHeadingFontSize => headingFontSize;
  get getAccentColorWithOpacity => accentColorWithOpacity;
  get getIconNavScale => iconNavScale;

  set setPrimaryColor(Color value) {
    primaryColor = value;
    notifyListeners();
  }

  set setIconNavScale(double value) {
    iconNavScale = value;
    notifyListeners();
  }

  set setAccentColorWithOpacity(Color value) {
    accentColorWithOpacity = value;
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

  set setSecondaryColor(Color value) {
    secondaryColor = value;
    notifyListeners();
  }

  set setAccentColor(Color value) {
    accentColor = value;
    notifyListeners();
  }
}
