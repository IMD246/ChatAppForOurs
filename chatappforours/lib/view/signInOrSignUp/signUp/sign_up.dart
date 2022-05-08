import 'package:chatappforours/extensions/locallization.dart';
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
              title: context.loc.email_already_in_use_error,
              text: context.loc.email_already_in_use,
            );
          } else if (state.exception is AuthEmailNeedsVefiricationException) {
            await showErrorDialog(
                context: context,
                title: context.loc.verification_email_error,
                text: context.loc.check_your_email_to_verification(state.email!),);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context: context,
              title: context.loc.generic_error,
              text: context.loc.auth_error,
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
