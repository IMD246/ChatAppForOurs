import 'package:flutter/material.dart';
@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;

  const AuthEventLogIn(this.email, this.password);
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
class AuthEventForgetPassword extends AuthEvent {
  final String? email;
  const AuthEventForgetPassword({required this.email});
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  const AuthEventRegister(this.email, this.password, this.fullName);
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventSignInWithFacebook extends AuthEvent {
  const AuthEventSignInWithFacebook();
}

class AuthEventSignInWithGoogle extends AuthEvent {
  const AuthEventSignInWithGoogle();
}

