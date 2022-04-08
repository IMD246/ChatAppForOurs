import 'package:chatappforours/services/bloc/validator/check_format_field_bloc.dart';
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckFormatFieldBloc(),
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: BodySignIn(),
      ),
    );
  }
}
