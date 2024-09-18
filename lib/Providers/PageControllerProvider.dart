import 'package:flutter/material.dart';

class Pagecontrollerprovider extends ChangeNotifier {
  PageController pageController = PageController();
  int pageIndex = 0;
  final List _pagesNamesThatExist = ["Home", "Folders", "Notes"];

  int get getPageIndex => pageIndex;

  PageController get getPageController => pageController;

  String get getCurrentPageName {
    print("page indes $pageIndex");
    return _pagesNamesThatExist[pageIndex];
  }

  List get getExitingPages => _pagesNamesThatExist;

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

    setPageIndex = index;
  }
}
