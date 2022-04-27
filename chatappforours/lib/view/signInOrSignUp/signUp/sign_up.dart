import 'package:chatappforours/services/auth/models/auth_exception.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/utilities/dialogs/error_dialog.dart';
import 'package:chatappforours/view/signInOrSignUp/signUp/components/body_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context: context,
              title: 'Email Already In Use Error',
              text: "Email Already In Use",
            );
          } else if (state.exception is AuthEmailNeedsVefiricationException) {
            await showErrorDialog(
                context: context,
                title: 'Verification Error Dialog',
                text: "Check gmail ${[state.email]} to verification");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
                context: context, title: 'Generic error', text: "Auth Error");
          }
        } else if (state is AuthStateRegiseringWithFacebook) {
          if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context: context,
              title: 'Email Already In Use Error',
              text: "Email Already In Use",
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context: context,
              title: 'Generic error',
              text: "Register facebook failed",
            );
          }
        } else if (state is AuthStateRegiseringWithGoogle) {
          if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context: context,
              title: 'Email Already In Use Error',
              text: "Email Already In Use",
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context: context,
              title: 'Generic error',
              text: "Register google failed",
            );
          }
        }
      },
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: BodySignUp(),
      ),
    );
  }
}
