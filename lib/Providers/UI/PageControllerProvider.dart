import 'package:flutter/material.dart';

class Pagecontrollerprovider extends ChangeNotifier {
  PageController pageController = PageController();
  int pageIndex = 0;

  final Map _pagesNamesThatExist = {"Home": 0, "Folders": 1, "Settings": 2};

  int get getPageIndex => pageIndex;

  PageController get getPageController => pageController;

  String get getCurrentPageName {
    String name = "";

    _pagesNamesThatExist
        .forEach((key, value) => value == getPageIndex ? name = key : null);

    print("name $name");

    return name;
  }

  Map get getAllPagesNames => _pagesNamesThatExist;

  set setPageIndex(int value) {
    pageIndex = value;
    notifyListeners();
  }

  set setPageController(PageController value) {
    pageController = value;
    notifyListeners();
  }

  void goBackPage(int index, BuildContext context) {
    pageController.previousPage(
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
    setPageIndex = index;
  }

  void goNextPage(int index, BuildContext context) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);

    setPageIndex = index;
  }
}
