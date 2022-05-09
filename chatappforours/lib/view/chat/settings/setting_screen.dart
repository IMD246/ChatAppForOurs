import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/models/auth_user.dart';

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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: buildAppbar(themeMode: ThemeMode.light, context: context),
          body: const BodySetting(),
        );
      },
    );
  }
}

AppBar buildAppbar(
    {required ThemeMode themeMode,
    required BuildContext context,
    AuthUser? authUser}) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: textColorMode(themeMode),
        ),
        Text(
          context.loc.me,
          style: TextStyle(
            color: textColorMode(themeMode),
          ),
        ),
      ],
    ),
  );
}
