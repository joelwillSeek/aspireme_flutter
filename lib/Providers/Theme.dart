import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  double iconScale = 2.0;
  double headingFontSize = 30.0;
  double iconNavScale = 10.0;

  get getIconScale => iconScale;
  get getHeadingFontSize => headingFontSize;
  get getIconNavScale => iconNavScale;

  set setIconNavScale(double value) {
    iconNavScale = value;
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
