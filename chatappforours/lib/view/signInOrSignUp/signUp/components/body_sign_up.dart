import 'package:chatappforours/utilities/button/primary_button.dart';
import 'package:chatappforours/utilities/textField/text_field.dart';
import 'package:chatappforours/utilities/validator/check_format_field.dart';
import 'package:chatappforours/view/chat/chatScreen/chat_screen.dart';
import 'package:chatappforours/view/signInOrSignUp/signIn/sign_in.dart';
import 'package:chatappforours/view/signInOrSignUp/signUp/components/or_divider.dart';
import 'package:chatappforours/view/signInOrSignUp/signUp/components/social_icon.dart';
import 'package:chatappforours/view/signInOrSignUp/text_field_container.dart';
import 'package:flutter/material.dart';
import '../../../../constants/constants.dart';

class BodySignUp extends StatefulWidget {
  const BodySignUp({Key? key}) : super(key: key);

  @override
  State<BodySignUp> createState() => _BodySignUpState();
}

class _BodySignUpState extends State<BodySignUp> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController email;
  late final TextEditingController password;
  late final TextEditingController firstName;
  late final TextEditingController lastName;

  bool isVisiblePassWord = false;
  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    firstName = TextEditingController();
    lastName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    firstName.dispose();
    lastName.dispose();
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
                    ? "assets/images/Register_Image.png"
                    : "assets/images/chat_logo_dark.png",
                height: 200,
                colorBlendMode: BlendMode.darken,
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
                        textHint: 'Type Your First Name',
                        icon: Icons.account_circle,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: firstName,
                    ),
                  ),
                  TextFieldContainer(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        return checkName(val!);
                      },
                      decoration: inputDecoration(
                        context: context,
                        textHint: 'Type Your Last Name',
                        icon: Icons.account_circle,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: lastName,
                    ),
                  ),
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
                      validator: (val) {
                        return checkPassword(val!);
                      },
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: PrimaryButton(
                text: 'Sign Up',
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account!",
                  style: TextStyle(
                    color: textColorMode(context),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignIn(),
                      ),
                    );
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SocialIcon(urlImage: "assets/icons/facebook.svg"),
                SizedBox(width: kDefaultPadding),
                SocialIcon(urlImage: "assets/icons/google-dark.svg"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
