import 'package:flutter/material.dart';

class Pagecontrollerprovider extends ChangeNotifier {
  PageController pageController = PageController();
  int pageIndex = 0;
  List pagesNamesThatExist = ["Home", "Folders"];

  int get getPageIndex => pageIndex;

  PageController get getPageController => pageController;
  String get getCurrentPageName {
    return pagesNamesThatExist[pageIndex];
  }

  set setPageIndex(int value) {
    pageIndex = value;
    notifyListeners();
  }

  set setPageController(PageController value) {
    pageController = value;
    notifyListeners();
  }

  void changePage(int index, BuildContext context) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }
}
