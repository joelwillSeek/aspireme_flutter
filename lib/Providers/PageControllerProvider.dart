import 'package:flutter/material.dart';

class Pagecontrollerprovider extends ChangeNotifier {
  PageController pageController = PageController();
  int pageIndex = 0;
  final List _pagesNamesThatExist = ["Home", "Folders", "Notes"];

  int get getPageIndex => pageIndex;

  PageController get getPageController => pageController;

  String get getCurrentPageName => _pagesNamesThatExist[pageIndex];

  List get getAllPagesNames => _pagesNamesThatExist;

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
