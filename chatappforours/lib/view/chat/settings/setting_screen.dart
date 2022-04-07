import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/bloc/theme/theme_bloc.dart';
import 'package:chatappforours/services/bloc/theme/theme_state.dart';
import 'package:chatappforours/view/chat/settings/components/body_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
     return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
          return Scaffold(
      appBar: buildAppbar(themeMode: state.themeMode),
      body:const BodySetting(),
    );
      },
    );
  
  }

  AppBar buildAppbar({required ThemeMode themeMode}) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(color: textColorMode(themeMode)),
          Text(
            'Me',
            style: TextStyle(
              color: textColorMode(themeMode),
            ),
          ),
        ],
      ),
    );
  }
}
