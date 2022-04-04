import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/utilities/button/primary_button.dart';
import 'package:chatappforours/view/chat/chatScreen/chat_screen.dart';
import 'package:flutter/material.dart';

class SignInOrSignUp extends StatelessWidget {
  const SignInOrSignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Center(
              child: Image.asset(
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? "assets/images/chat_logo_white.png"
                    : "assets/images/chat_logo_dark.png",
                height: 246,
              ),
            ),
            const Spacer(),
            PrimaryButton(
              text: 'Sign In',
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: kDefaultPadding * 1.5),
            PrimaryButton(
              text: 'Sign Up',
              press: () {},
              color: kSecondaryColor,
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
