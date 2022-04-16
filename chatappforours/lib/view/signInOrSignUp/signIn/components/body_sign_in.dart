import 'package:chatappforours/services/auth/auth_exception.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/utilities/button/primary_button.dart';
import 'package:chatappforours/utilities/dialogs/error_dialog.dart';
import 'package:chatappforours/utilities/textField/text_field.dart';
import 'package:chatappforours/utilities/validator/check_format_field.dart';
import 'package:chatappforours/view/chat/chat_screen.dart';
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
  String errorStringEmail = '';
  String errorStringPassWord = '';
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
    return BlocBuilder<AuthBloc, AuthState>(
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
                            onTap: () {
                              setState(() {
                                errorStringEmail = checkFormatEmail(email.text);
                              });
                            },
                            onChanged: (val) {
                              setState(() {
                                errorStringEmail = checkFormatEmail(val);
                              });
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
                            visible: errorStringEmail.isNotEmpty,
                            child: Text(
                              errorStringEmail,
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
                            onTap: () {
                              setState(() {
                                errorStringPassWord =
                                    checkPassword(password.text);
                              });
                            },
                            onChanged: (val) {
                              setState(() {
                                errorStringPassWord = checkPassword(val);
                              });
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
                            visible: errorStringPassWord.isNotEmpty,
                            child: Text(
                              errorStringPassWord,
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
                    context: context,
                    text: 'Sign In',
                    press: () async {
                      if (errorStringEmail.isEmpty &&
                          errorStringPassWord.isEmpty) {
                        {
                          context.read<AuthBloc>().add(
                                AuthEventLogIn(email.text, password.text),
                              );
                        }
                      }
                    },
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
                        context.read<AuthBloc>().add(
                              const AuthEventShouldRegister(),
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
      },
    );
  }
}
