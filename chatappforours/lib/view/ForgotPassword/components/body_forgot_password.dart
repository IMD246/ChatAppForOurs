import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/utilities/button/primary_button.dart';
import 'package:chatappforours/utilities/dialogs/password_reset_email_sent_dialog.dart';
import 'package:chatappforours/utilities/textField/text_field.dart';
import 'package:chatappforours/utilities/validator/check_format_field.dart';
import 'package:chatappforours/view/signInOrSignUp/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/constants.dart';

class BodyForgotPassword extends StatefulWidget {
  const BodyForgotPassword({Key? key}) : super(key: key);

  @override
  State<BodyForgotPassword> createState() => _BodyForgotPasswordState();
}

class _BodyForgotPasswordState extends State<BodyForgotPassword> {
  late final TextEditingController email;
  String errorStringEmail = '';
  @override
  void initState() {
    email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassWord) {
          if (state.hasSentEmail) {
            await showPasswordResetSentDialog(
              context: context,
              text: "Check your gmail ${[email.text]} to reset password",
            );
            email.clear();
          }
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                child: Center(
                  child: Image.asset(
                    "assets/images/reset-password.png",
                    height: 246,
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
                ],
              ),
              SizedBox(height: size.height * 0.03),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: PrimaryButton(
                  context: context,
                  text: 'Send Email',
                  press: () {
                    if (errorStringEmail.isEmpty) {
                      {
                        context.read<AuthBloc>().add(
                              AuthEventForgetPassword(
                                email: email.text,
                              ),
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
                    "Already remember password!",
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
            ],
          ),
        ),
      ),
    );
  }
}
