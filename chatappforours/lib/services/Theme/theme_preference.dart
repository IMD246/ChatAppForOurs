import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference {
  static const themeStatus = 'THEME_STATUS';
  void setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(themeStatus, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(themeStatus) ?? false;
  }
}
