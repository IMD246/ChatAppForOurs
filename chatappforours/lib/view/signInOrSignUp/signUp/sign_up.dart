import 'package:chatappforours/services/bloc/validator/check_format_field_bloc.dart';
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
    return BlocProvider(
      create: (context) => CheckFormatFieldBloc(),
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: BodySignUp(),
      ),
    );
  }
}
