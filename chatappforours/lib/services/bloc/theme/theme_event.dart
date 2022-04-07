import 'package:flutter/material.dart';

@immutable
abstract class ThemeEvent {
  final bool isOn;

  const ThemeEvent(this.isOn);
}

class ChangeDarkModeThemeEvent extends ThemeEvent {
  const ChangeDarkModeThemeEvent(bool isOn) : super(isOn);
  
}
