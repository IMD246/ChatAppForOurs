import 'package:chatappforours/services/auth/models/auth_exception.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/utilities/dialogs/error_dialog.dart';
import 'package:chatappforours/view/signInOrSignUp/signIn/components/body_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
                context: context,
                title: 'User not found error',
                text: "User not found in Database");
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
                context: context,
                title: 'Wrong password error',
                text: "Wrong password");
          } else if (state.exception is AuthEmailNeedsVefiricationException) {
            await showErrorDialog(
                context: context,
                title: 'Verification Error Dialog',
                text: "Check your gmail ${[state.email]} to verification");
          }
        }
        if (state is AuthStateSignInWithGoogle) {
          if (state.exception is UserNotLoggedInAuthException) {
            await showErrorDialog(
              context: context,
              title: "User doesn't logged in error",
              text: "User doesn't Logged in",
            );
          }
        }
      },
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: BodySignIn(),
      ),
    );
  }
}
