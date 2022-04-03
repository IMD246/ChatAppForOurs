import 'package:chatappforours/view/welcome/signInOrSignUp/sign_in_or_sign_up.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            FittedBox(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInOrSignUp(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'Skip',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.color
                                ?.withOpacity(0.8),
                          ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.color
                          ?.withOpacity(0.8),
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
