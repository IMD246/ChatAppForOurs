import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/Theme/theme_changer.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/utilities/loading/loading_screen.dart';
import 'package:chatappforours/view/ForgotPassword/forgot_password.dart';
import 'package:chatappforours/view/chat/chatScreen/chat_screen.dart';
import 'package:chatappforours/view/chat/messageScreen/message_screen.dart';
import 'package:chatappforours/view/chat/settings/setting_screen.dart';
import 'package:chatappforours/view/signInOrSignUp/signIn/sign_in.dart';
import 'package:chatappforours/view/signInOrSignUp/signUp/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeChanger themeChanger = Provider.of<ThemeChanger>(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        final FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
        if (state is AuthStateLoggedIn) {
          final userProfile = await firebaseUserProfile.getUserProfile(
              userID: state.authUser.id);
          themeChanger.setTheme(
            userProfile!.isDarkMode,
          );
        }
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedOut) {
          return const SignIn();
        } else if (state is AuthStateGetInChatFromBodyChatScreen) {
          return MesssageScreen(
            chat: state.chat,
            currentIndex: 0,
          );
        } else if (state is AuthStateGetInChatFromBodyContactScreen) {
          return MesssageScreen(
            chat: state.chat,
            currentIndex: 1,
          );
        } else if (state is AuthStateGetOutChatFromBodyChatScreen) {
          return const ChatScreen(
            currentIndex: 0,
          );
        } else if (state is AuthStateGetOutChatFromBodyContactScreen) {
          return const ChatScreen(
            currentIndex: 1,
          );
        } else if (state is AuthStateLoggedIn) {
          return const ChatScreen(
            currentIndex: 0,
          );
        } else if (state is AuthStateRegistering) {
          return const SignUp();
        } else if (state is AuthStateSetting) {
          return const SettingScreen();
        } else if (state is AuthStateForgotPassWord) {
          return const ForgotPassword();
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
                        context.read<AuthBloc>().add(
                              const AuthEventInitialize(),
                            );
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
