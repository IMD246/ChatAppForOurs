import 'package:chatappforours/services/bloc/theme/theme_bloc.dart';
import 'package:chatappforours/utilities/theme/theme_data.dart';
import 'package:chatappforours/services/bloc/theme/theme_state.dart';
import 'package:chatappforours/view/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightThemeData(context),
            darkTheme: darkThemeData(context),
            themeMode: (state is ThemeStateValid) ? state.themeMode : ThemeMode.light,
            home: const WelcomePage(),
          );
        },
      ),
    );
  }
}
