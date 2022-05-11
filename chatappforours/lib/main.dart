import 'package:chatappforours/services/Theme/theme_changer.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/crud/firebase_auth_provider.dart';
import 'package:chatappforours/utilities/theme/theme_data.dart';
import 'package:chatappforours/view/welcome/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();
  await FirebaseMessaging.instance.getInitialMessage();
  runApp(const StartApp());
}

class StartApp extends StatefulWidget {
  const StartApp({Key? key}) : super(key: key);

  @override
  State<StartApp> createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(),
      child: const Material(),
    );
  }
}

class Material extends StatefulWidget {
  const Material({
    Key? key,
  }) : super(key: key);

  @override
  State<Material> createState() => _MaterialState();
}

class _MaterialState extends State<Material> {
  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    final isDarkTheme = themeChanger.getTheme();
    final language = themeChanger.langugage.substring(0, 2).toString();
    final String defaultLocale = Platform.localeName.substring(0, 2).toString();
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        locale: language.compareTo(defaultLocale) == 0
            ? Locale(defaultLocale)
            : Locale(language),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        debugShowCheckedModeBanner: false,
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
        home: const WelcomePage(),
      ),
    );
  }
}
