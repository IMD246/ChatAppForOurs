import 'package:chatappforours/utilities/button/primary_button.dart';
import 'package:chatappforours/utilities/textField/text_field.dart';
import 'package:chatappforours/utilities/validator/check_format_field.dart';
import 'package:chatappforours/view/chat/chatScreen/chat_screen.dart';
import 'package:chatappforours/view/signInOrSignUp/signUp/sign_up.dart';
import 'package:chatappforours/view/signInOrSignUp/text_field_container.dart';
import 'package:flutter/material.dart';

import '../../../../constants/constants.dart';

class BodySignIn extends StatefulWidget {
  const BodySignIn({Key? key}) : super(key: key);

  @override
  State<BodySignIn> createState() => _BodySignInState();
}

class _BodySignInState extends State<BodySignIn> {
  final _formKey = GlobalKey<FormState>();
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.asset(
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? "assets/images/chat_logo_white.png"
                    : "assets/images/chat_logo_dark.png",
                height: 246,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFieldContainer(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        return checkFormatEmail(val!);
                      },
                      decoration: inputDecoration(
                        context: context,
                        textHint: 'Type Your Email',
                        icon: Icons.email,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
                    ),
                  ),
                  TextFieldContainer(
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      validator: (val) => checkPassword(val!),
                      decoration: inputDecoration(
                        context: context,
                        textHint: 'Type Your Password',
                        icon: Icons.lock,
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
                            color: textColorMode(context),
                          ),
                        ),
                      ),
                      controller: password,
                      obscureText: !isVisiblePassWord ? true : false,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.03),
            PrimaryButton(
              text: 'Sign In',
              press: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatScreen(),
                    ),
                  );
                }
              },
              context: context,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have account!",
                  style: TextStyle(
                    color: textColorMode(context),
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
  }
}
