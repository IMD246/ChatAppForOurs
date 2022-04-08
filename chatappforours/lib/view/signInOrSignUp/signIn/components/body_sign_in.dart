import 'package:chatappforours/services/bloc/theme/theme_bloc.dart';
import 'package:chatappforours/services/bloc/theme/theme_state.dart';
import 'package:chatappforours/services/bloc/validator/check_format_field_bloc.dart';
import 'package:chatappforours/services/bloc/validator/check_format_field_event.dart';
import 'package:chatappforours/services/bloc/validator/check_format_field_state.dart';
import 'package:chatappforours/utilities/button/primary_button.dart';
import 'package:chatappforours/utilities/textField/text_field.dart';
import 'package:chatappforours/view/chat/chat_screen.dart';
import 'package:chatappforours/view/signInOrSignUp/signUp/sign_up.dart';
import 'package:chatappforours/view/signInOrSignUp/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/constants.dart';

class BodySignIn extends StatefulWidget {
  const BodySignIn({Key? key}) : super(key: key);

  @override
  State<BodySignIn> createState() => _BodySignInState();
}

class _BodySignInState extends State<BodySignIn> {
  late final TextEditingController email;
  late final TextEditingController password;
  bool isVisiblePassWord = false;
  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
      return BlocBuilder<CheckFormatFieldBloc, CheckFormatFieldState>(
          builder: (context, state) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/chat_logo_white.png",
                    height: 246,
                  ),
                ),
                Column(
                  children: [
                    TextFieldContainer(
                      child: Column(
                        children: [
                          TextField(
                            textInputAction: TextInputAction.next,
                            onChanged: (val) {
                              context.read<CheckFormatFieldBloc>().add(
                                    CheckFormatEmailFieldEvent(val),
                                  );
                            },
                            decoration: inputDecoration(
                              context: context,
                              textHint: 'Type Your Email',
                              icon: Icons.email,
                              color: textColorMode(ThemeMode.light),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            controller: email,
                          ),
                          Visibility(
                            visible: (state is CheckFormatFieldEmailState)
                                ? state.value.isNotEmpty
                                : false,
                            child: Text(
                              state.value,
                              style: const TextStyle(
                                color: kErrorColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextFieldContainer(
                      child: Column(
                        children: [
                          TextField(
                            textInputAction: TextInputAction.done,
                            onChanged: (val) {
                              context.read<CheckFormatFieldBloc>().add(
                                    CheckFormatPasswordFieldEvent(val),
                                  );
                            },
                            decoration: inputDecoration(
                              context: context,
                              textHint: 'Type Your Password',
                              icon: Icons.lock,
                              color: textColorMode(ThemeMode.light),
                            ).copyWith(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(
                                    () {
                                      isVisiblePassWord = !isVisiblePassWord;
                                    },
                                  );
                                },
                                icon: Icon(
                                  isVisiblePassWord
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: textColorMode(ThemeMode.light),
                                ),
                              ),
                            ),
                            controller: password,
                            obscureText: !isVisiblePassWord ? true : false,
                          ),
                          Visibility(
                            visible: (state is CheckFormatFieldPasswordState)
                                ? state.value.isNotEmpty
                                : false,
                            child: Text(
                              state.value,
                              style: const TextStyle(
                                color: kErrorColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: PrimaryButton(
                    text: 'Sign In',
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatScreen(),
                        ),
                      );
                    },
                    context: context,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have account!",
                      style: TextStyle(
                        color: textColorMode(ThemeMode.light),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUp(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Forgot Password'),
                )
              ],
            ),
          ),
        );
      });
    });
  }
}
