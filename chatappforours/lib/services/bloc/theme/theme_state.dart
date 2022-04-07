import 'package:flutter/material.dart';

@immutable
abstract class ThemeState {
  final ThemeMode themeMode;
  const ThemeState(this.themeMode);
}

class ThemeStateValid extends ThemeState {
  const ThemeStateValid(ThemeMode themeMode) : super(themeMode);
}
