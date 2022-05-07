import 'dart:io';

import 'package:chatappforours/extensions/locallization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ThemeChanger with ChangeNotifier {
  bool isDarkTheme = false;
  String langugage = Platform.localeName.substring(0,2);
  late BuildContext context;
  bool getTheme() => isDarkTheme;
  String getLanguage() {
    if (langugage.compareTo("vi") == 0) {
      return context.loc.vietnamese;
    } else {
      return context.loc.english;
    }
  }

  void setContext({required BuildContext context}) {
    this.context = context;
  }

  void setTheme(bool value) {
    isDarkTheme = value;
    notifyListeners();
  }

  void setLanguge(String value) {
    langugage = value;
    notifyListeners();
  }
}
