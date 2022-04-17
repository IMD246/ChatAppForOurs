import 'package:chatappforours/services/auth/auth_exception.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/utilities/dialogs/error_dialog.dart';
import 'package:chatappforours/view/ForgotPassword/components/body_forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassWord) {
          if (state.exception is UserNotFoundAuthException &&
              state.exception != null) {
            await showErrorDialog(
              context: context,
              title: 'User not found in database error',
              text: "User not found in database",
            );
          }
        }
      },
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: BodyForgotPassword(),
      ),
    );
  }
}
