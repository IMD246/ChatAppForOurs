import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);
const kColorDarkMode = Color.fromARGB(18, 18, 18, 1);
const kDefaultPadding = 20.0;
const defaultValue = 'default';
const int intMaxValue = 9223372036854775807;
Color textColorMode(ThemeMode themeMode) {
  return themeMode == ThemeMode.light ? Colors.black : Colors.white;
}
