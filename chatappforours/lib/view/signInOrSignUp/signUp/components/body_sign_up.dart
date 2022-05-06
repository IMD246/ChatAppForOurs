import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/models/auth_exception.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/utilities/button/primary_button.dart';
import 'package:chatappforours/utilities/textField/text_field.dart';
import 'package:chatappforours/utilities/validator/check_format_field.dart';
import 'package:chatappforours/utilities/textField/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../constants/constants.dart';

class BodySignUp extends StatefulWidget {
  const BodySignUp({Key? key}) : super(key: key);

  @override
  State<BodySignUp> createState() => _BodySignUpState();
}

class _BodySignUpState extends State<BodySignUp> {
  late final TextEditingController email;
  late final TextEditingController password;
  late final TextEditingController firstName;
  late final TextEditingController lastName;
  String errorStringEmail = '';
  String errorStringPassWord = '';
  String errorStringFirstName = '';
  String errorStringLastName = '';
  bool isVisiblePassWord = false;
  final FocusNode focusNode = FocusNode(canRequestFocus: true);
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
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is AuthEmailNeedsVefiricationException) {
            email.clear();
            password.clear();
            firstName.clear();
            lastName.clear();
          }
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (!isKeyboard)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                  child: Center(
                    child: Image.asset(
                      "assets/images/Register_Image.png",
                      height: 185,
                    ),
                  ),
                ),
              Column(
                children: [
                  TextFieldContainer(
                    child: Column(
                      children: [
                        TextField(
                          style:
                              TextStyle(color: textColorMode(ThemeMode.light)),
                          textInputAction: TextInputAction.next,
                          onTap: () {
                            setState(() {
                              errorStringFirstName =
                                  checkFirstName(firstName.text,context);
                            });
                          },
                          onChanged: (val) {
                            setState(() {
                              errorStringFirstName = checkFirstName(val,context);
                            });
                          },
                          decoration: inputDecoration(
                            context: context,
                            textHint: context.loc.type_your_first_name,
                            icon: Icons.account_circle,
                            color: textColorMode(ThemeMode.light),
                          ),
                          keyboardType: TextInputType.text,
                          controller: firstName,
                        ),
                        Visibility(
                          visible: errorStringFirstName.isNotEmpty,
                          child: Text(
                            errorStringFirstName,
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
                          style:
                              TextStyle(color: textColorMode(ThemeMode.light)),
                          textInputAction: TextInputAction.next,
                          onTap: () {
                            setState(() {
                              errorStringLastName =
                                  checkFirstName(lastName.text,context);
                            });
                          },
                          onChanged: (val) {
                            setState(
                              () {
                                errorStringLastName = checkFirstName(val,context);
                              },
                            );
                          },
                          decoration: inputDecoration(
                            context: context,
                            textHint: context.loc.type_your_last_name,
                            icon: Icons.account_circle,
                            color: textColorMode(ThemeMode.light),
                          ),
                          keyboardType: TextInputType.text,
                          controller: lastName,
                        ),
                        Visibility(
                          visible: errorStringLastName.isNotEmpty,
                          child: Text(
                            errorStringLastName,
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
                          style:
                              TextStyle(color: textColorMode(ThemeMode.light)),
                          textInputAction: TextInputAction.next,
                          onTap: () {
                            setState(() {
                              errorStringEmail = checkFormatEmail(email.text,context);
                            });
                          },
                          onChanged: (val) {
                            setState(() {
                              errorStringEmail = checkFormatEmail(val,context);
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
                                errorStringFirstName.isEmpty &&
                                errorStringLastName.isEmpty &&
                                errorStringPassWord.isEmpty) {
                              context.read<AuthBloc>().add(
                                    AuthEventRegister(
                                      email.text,
                                      password.text,
                                      "${firstName.text} ${lastName.text}",
                                    ),
                                  );
                            }
                          },
                          style:
                              TextStyle(color: textColorMode(ThemeMode.light)),
                          textInputAction: TextInputAction.done,
                          onTap: () {
                            setState(() {
                              errorStringPassWord =
                                  checkPassword(password.text,context);
                            });
                          },
                          onChanged: (val) {
                            setState(() {
                              errorStringPassWord = checkPassword(val,context);
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
              SizedBox(height: size.height * 0.01),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: PrimaryButton(
                  text: 'Sign Up',
                  press: () {
                    if (errorStringEmail.isEmpty &&
                        errorStringFirstName.isEmpty &&
                        errorStringLastName.isEmpty &&
                        errorStringPassWord.isEmpty) {
                      context.read<AuthBloc>().add(
                            AuthEventRegister(
                              email.text,
                              password.text,
                              "${firstName.text} ${lastName.text}",
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
                    context.loc.already_have_an_account,
                    style: TextStyle(
                      color: textColorMode(ThemeMode.light),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    },
                    child: Text(
                      context.loc.sign_in,
                      style:const TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
