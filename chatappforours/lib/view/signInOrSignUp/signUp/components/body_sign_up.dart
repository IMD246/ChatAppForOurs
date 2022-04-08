import 'package:chatappforours/services/bloc/validator/check_format_field_bloc.dart';
import 'package:chatappforours/services/bloc/validator/check_format_field_event.dart';
import 'package:chatappforours/services/bloc/validator/check_format_field_state.dart';
import 'package:chatappforours/utilities/button/primary_button.dart';
import 'package:chatappforours/utilities/textField/text_field.dart';
import 'package:chatappforours/view/chat/chat_screen.dart';
import 'package:chatappforours/view/signInOrSignUp/signIn/sign_in.dart';
import 'package:chatappforours/view/signInOrSignUp/signUp/components/or_divider.dart';
import 'package:chatappforours/view/signInOrSignUp/signUp/components/social_icon.dart';
import 'package:chatappforours/view/signInOrSignUp/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late FocusNode focusNode;

  bool isVisiblePassWord = false;
  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    firstName = TextEditingController();
    lastName = TextEditingController();
    focusNode = FocusNode();
    focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    firstName.dispose();
    lastName.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<CheckFormatFieldBloc, CheckFormatFieldState>(
        builder: (context, state) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  "assets/images/Register_Image.png",
                  height: 200,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFieldContainer(
                      child: Column(
                        children: [
                          TextField(
                            focusNode: focusNode,
                            textInputAction: TextInputAction.next,
                            onTap: () {
                              context.read<CheckFormatFieldBloc>().add(
                                    CheckFormatFirstNameFieldEvent(
                                        firstName.text),
                                  );
                            },
                            onChanged: (val) {
                              context.read<CheckFormatFieldBloc>().add(
                                    CheckFormatFirstNameFieldEvent(val),
                                  );
                            },
                            decoration: inputDecoration(
                              context: context,
                              textHint: 'Type Your First Name',
                              icon: Icons.account_circle,
                              color: textColorMode(ThemeMode.light),
                            ),
                            keyboardType: TextInputType.text,
                            controller: firstName,
                          ),
                          Visibility(
                            visible: (state is CheckFormatFieldFirstNameState)
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
                            textInputAction: TextInputAction.next,
                            onTap: () {
                              context.read<CheckFormatFieldBloc>().add(
                                    CheckFormatLastNameFieldEvent(
                                        lastName.text),
                                  );
                            },
                            onChanged: (val) {
                              context.read<CheckFormatFieldBloc>().add(
                                    CheckFormatLastNameFieldEvent(val),
                                  );
                            },
                            decoration: inputDecoration(
                              context: context,
                              textHint: 'Type Your Last Name',
                              icon: Icons.account_circle,
                              color: textColorMode(ThemeMode.light),
                            ),
                            keyboardType: TextInputType.text,
                            controller: lastName,
                          ),
                          Visibility(
                            visible: (state is CheckFormatFieldLastNameState)
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
                            textInputAction: TextInputAction.next,
                            onTap: () {
                              context.read<CheckFormatFieldBloc>().add(
                                    CheckFormatEmailFieldEvent(email.text),
                                  );
                            },
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
                            onTap: () {
                              context.read<CheckFormatFieldBloc>().add(
                                    CheckFormatPasswordFieldEvent(
                                        password.text),
                                  );
                            },
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
              ),
              SizedBox(height: size.height * 0.03),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: PrimaryButton(
                  text: 'Sign Up',
                  press: () {
                    if (firstName.text.isEmpty) {
                      context.read<CheckFormatFieldBloc>().add(
                            CheckFormatFirstNameFieldEvent(firstName.text),
                          );
                    } else if (lastName.text.isEmpty) {
                      context.read<CheckFormatFieldBloc>().add(
                            CheckFormatLastNameFieldEvent(lastName.text),
                          );
                    } else if (email.text.isEmpty) {
                      context.read<CheckFormatFieldBloc>().add(
                            CheckFormatEmailFieldEvent(email.text),
                          );
                    } else if (password.text.isEmpty) {
                      context.read<CheckFormatFieldBloc>().add(
                            CheckFormatPasswordFieldEvent(password.text),
                          );
                    } else {
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
                      color: textColorMode(ThemeMode.light),
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
                  SocialIcon(urlImage: "assets/icons/facebook-white.svg"),
                  SizedBox(width: kDefaultPadding),
                  SocialIcon(urlImage: "assets/icons/google-light.svg"),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
