import 'package:chatappforours/constants/constants.dart';
import 'package:flutter/material.dart';

import '../signInOrSignUp/signIn/sign_in.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignIn(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'Skip',
                      style: TextStyle(
                        color: textColorMode(ThemeMode.light).withOpacity(0.8),
                        fontSize: 24,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: textColorMode(ThemeMode.light).withOpacity(0.7),
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
}
