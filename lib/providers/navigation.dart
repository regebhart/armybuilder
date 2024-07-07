import 'package:flutter/material.dart';

class NavigationNotifier extends ChangeNotifier {
  late PageController _pageController;
  late PageController _browsingPageController;
  late PageController _builderPageController;
  bool _swiping = false;

  PageController get pageController => _pageController;
  PageController get browsingPageController => _browsingPageController;
  PageController get builderPageController => _builderPageController;

  bool get swiping => _swiping;

  NavigationNotifier();

  setPageController(PageController con) {
    _pageController = con;
  }

  setBuilderPageController(PageController con) {
    _builderPageController = con;
  }

  setBrowsingPageController(PageController con) {
    _browsingPageController = con;
  }

  setSwiping(bool value) {
    _swiping = value;
  }
}
