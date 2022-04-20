import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ThemeChanger with ChangeNotifier {
  bool isDarkTheme = false;
  bool getTheme() => isDarkTheme;

  setTheme(bool value) {
    isDarkTheme = value;
    notifyListeners();
  }
}
