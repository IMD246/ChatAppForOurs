import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/utilities/button/primary_button.dart';
import 'package:chatappforours/utilities/textField/text_field.dart';
import 'package:chatappforours/utilities/validator/check_format_field.dart';
import 'package:chatappforours/view/signInOrSignUp/signUp/components/or_divider.dart';
import 'package:chatappforours/view/signInOrSignUp/signUp/components/social_icon.dart';
import 'package:chatappforours/utilities/textField/text_field_container.dart';
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.asset(
                "assets/images/chat_logo_white.png",
                height: size.height * 0.3,
              ),
            ),
            Column(
              children: [
                TextFieldContainer(
                  child: Column(
                    children: [
                      TextField(
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: textColorMode(ThemeMode.light)),
                        onTap: () {
                          setState(() {
                            errorStringEmail =
                                checkFormatEmail(email.text.trim(), context);
                          });
                        },
                        onChanged: (val) {
                          setState(() {
                            errorStringEmail =
                                checkFormatEmail(val.trim(), context);
                          });
                        },
                        decoration: inputDecoration(
                          context: context,
                          textHint: context.loc.type_your_email,
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
                        onSubmitted: (_) {
                          if (errorStringEmail.isEmpty &&
                              errorStringPassWord.isEmpty) {
                            {
                              context.read<AuthBloc>().add(
                                    AuthEventLogIn(email.text.trim(),
                                        password.text.trim()),
                                  );
                            }
                          }
                        },
                        textInputAction: TextInputAction.done,
                        style: TextStyle(color: textColorMode(ThemeMode.light)),
                        onTap: () {
                          setState(() {
                            errorStringPassWord =
                                checkPassword(password.text.trim(), context);
                          });
                        },
                        onChanged: (val) {
                          setState(() {
                            errorStringPassWord =
                                checkPassword(val.trim(), context);
                          });
                        },
                        decoration: inputDecoration(
                          context: context,
                          textHint: context.loc.type_your_password,
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
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: PrimaryButton(
                context: context,
                text: context.loc.sign_in,
                press: () {
                  if (errorStringEmail.isEmpty && errorStringPassWord.isEmpty) {
                    {
                      context.read<AuthBloc>().add(
                            AuthEventLogIn(
                                email.text.trim(), password.text.trim()),
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
                  context.loc.dont_have_account,
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
                  child: Text(
                    context.loc.sign_up,
                    style: const TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventForgetPassword(email: null),
                    );
              },
              child: Text(context.loc.forgot_password),
            ),
            const OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialIcon(
                  urlImage: "assets/icons/facebook-white.svg",
                  press: () {
                    context.read<AuthBloc>().add(
                          const AuthEventSignInWithFacebook(),
                        );
                  },
                ),
                const SizedBox(width: kDefaultPadding),
                SocialIcon(
                  urlImage: "assets/icons/google-light.svg",
                  press: () async {
                    context.read<AuthBloc>().add(
                          const AuthEventSignInWithGoogle(),
                        );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
