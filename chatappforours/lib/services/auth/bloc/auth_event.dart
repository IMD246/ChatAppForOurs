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

class AuthEventSetting extends AuthEvent {
  const AuthEventSetting();
}

class AuthEventSettingBack extends AuthEvent {
  const AuthEventSettingBack();
}

class AuthEventUploadImage extends AuthEvent {
  final String path;
  final String fileName;
  final BuildContext context;
  const AuthEventUploadImage(
      {required this.context, required this.path, required this.fileName});
}

class AuthEventUploadStateTheme extends AuthEvent {
  final bool isDarkTheme;
  const AuthEventUploadStateTheme({required this.isDarkTheme});
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

