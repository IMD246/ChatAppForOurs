import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/Theme/theme_changer.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_request_friend.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/utilities/loading/loading_screen.dart';
import 'package:chatappforours/view/ForgotPassword/forgot_password.dart';
import 'package:chatappforours/view/chat/chatScreen/chat_screen.dart';
import 'package:chatappforours/view/signInOrSignUp/signIn/sign_in.dart';
import 'package:chatappforours/view/signInOrSignUp/signUp/sign_up.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
  final FirebaseRequestFriend firebaseRequestFriend = FirebaseRequestFriend();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeChanger themeChanger = Provider.of<ThemeChanger>(context);
    Size size = MediaQuery.of(context).size;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    themeChanger.setContext(context: context);
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data! == ConnectivityResult.wifi) {
          return BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state is AuthStateLoggedIn) {
                final userProfile = state.userProfile;
                final String? token =
                    await FirebaseMessaging.instance.getToken();
                await firebaseUserProfile.updateTokenUserProfile(
                  token: token,
                  userID: state.userProfile.idUser,
                );
                themeChanger.setTheme(
                  userProfile.isDarkMode,
                );
                themeChanger.setLanguge(userProfile.language);
              }
              if (state.isLoading) {
                LoadingScreen().show(
                  context: context,
                  text: state.loadingText ?? context.loc.please_wait_a_moment,
                );
              } else {
                LoadingScreen().hide();
              }
            },
            builder: (context, state) {
              if (state is AuthStateLoggedOut) {
                return const SignIn();
              } else if (state is AuthStateLoggedIn) {
                return FutureBuilder<int?>(
                  future: firebaseRequestFriend.countAllRequestFriendFuture(
                    ownerUserID: state.userProfile.idUser!,
                  ),
                  builder: (context, snapShot) {
                    int countFriend = snapShot.hasData ? snapShot.data! : 0;
                    return ChatScreen(
                      countFriend: countFriend,
                      userProfile: state.userProfile,
                    );
                  },
                );
              } else if (state is AuthStateRegistering) {
                return const SignUp();
              } else if (state is AuthStateForgotPassWord) {
                return const ForgotPassword();
              } else {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Column(
                    children: [
                      const Spacer(flex: 1),
                      if (!isKeyboard)
                        Image.asset(
                          "assets/images/welcome_image.png",
                          height: size.height * 0.45,
                          width: size.width,
                        ),
                      const Spacer(flex: 2),
                      Text(
                        context.loc.welcome,
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
                          onPressed: () async {
                            context.read<AuthBloc>().add(
                                  const AuthEventInitialize(),
                                );
                          },
                          child: Row(
                            children: [
                              Text(
                                context.loc.skip,
                                style: TextStyle(
                                  color: textColorMode(ThemeMode.light)
                                      .withOpacity(0.8),
                                  fontSize: 24,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: textColorMode(ThemeMode.light)
                                    .withOpacity(0.7),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                );
              }
            },
          );
        } else {
          return Scaffold(
            body: Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: const CircularProgressIndicator(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      context.loc.please_check_internet,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
