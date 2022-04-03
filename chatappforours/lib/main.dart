import 'package:chatappforours/utilities/theme/theme_data.dart';
import 'package:chatappforours/view/welcome/welcome_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const StartApp());
}

class StartApp extends StatelessWidget {
  const StartApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      home: WelcomePage(),
    );
  }
}
