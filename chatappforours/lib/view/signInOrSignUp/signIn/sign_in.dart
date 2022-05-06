import 'package:chatappforours/extensions/locallization.dart';
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
                title: context.loc.user_not_found_in_database_error,
                text: context.loc.user_not_found_in_database);
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
                context: context,
                title: context.loc.wrong_password_error,
                text: context.loc.wrong_password);
          } else if (state.exception is AuthEmailNeedsVefiricationException) {
            await showErrorDialog(
                context: context,
                title: context.loc.verification_email_error,
                text: "${context.loc.check_your_email} ${[
                  state.email
                ]} ${context.loc.to_verification}");
          } else if (state.exception is UserNotLoggedInAuthException) {
            await showErrorDialog(
              context: context,
              title: context.loc.user_doesnt_logged_in_error,
              text: context.loc.user_doesnt_logged_in,
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
