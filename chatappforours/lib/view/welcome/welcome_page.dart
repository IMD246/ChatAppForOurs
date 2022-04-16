import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/view/chat/chat_screen.dart';
import 'package:chatappforours/view/chat/settings/setting_screen.dart';
import 'package:chatappforours/view/signInOrSignUp/signIn/sign_in.dart';
import 'package:chatappforours/view/signInOrSignUp/signUp/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const ChatScreen();
        } else if (state is AuthStateLoggedOut) {
          return const SignIn();
        } else if (state is AuthStateRegistering) {
          return const SignUp();
        } else if (state is AuthStateSetting) {
          return const SettingScreen();
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  Image.asset(
                    "assets/images/welcome_image.png",
                  ),
                  const Spacer(flex: 2),
                  Text(
                    "Welcome to chat app \nfor ours",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColorMode(ThemeMode.light),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const Spacer(),
                  FittedBox(
                    child: TextButton(
                      onPressed: () {
                        context
                            .read<AuthBloc>()
                            .add(const AuthEventInitialize());
                      },
                      child: Row(
                        children: [
                          Text(
                            'Skip',
                            style: TextStyle(
                              color: textColorMode(ThemeMode.light)
                                  .withOpacity(0.8),
                              fontSize: 24,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color:
                                textColorMode(ThemeMode.light).withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
