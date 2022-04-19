import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/auth_user.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';

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
        if (state is AuthStateSetting) {
          return Scaffold(
            appBar: buildAppbar(themeMode: ThemeMode.light, context: context),
            body: const BodySetting(),
          );
        } else {
          return const Scaffold();
        }
      },
    );
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
              context.read<AuthBloc>().add(
                    const AuthEventSettingBack(),
                  );
            },
            color: textColorMode(themeMode),
          ),
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
