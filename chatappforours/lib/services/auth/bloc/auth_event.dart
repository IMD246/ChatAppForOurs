// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:chatappforours/services/auth/models/chat.dart';

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

class AuthEventRegisterWithFacebook extends AuthEvent {
  const AuthEventRegisterWithFacebook();
}

class AuthEventRegisterWithGoogle extends AuthEvent {
  const AuthEventRegisterWithGoogle();
}

class AuthEventGetInChatFromBodyChatScreen extends AuthEvent {
  final Chat chat;
  final int currentIndex;
  const AuthEventGetInChatFromBodyChatScreen({required this.currentIndex,
    required this.chat,
  });
}

class AuthEventGetInChatFromBodyContactScreen extends AuthEvent {
  final Chat chat;
  final int currentIndex;
  const AuthEventGetInChatFromBodyContactScreen({required this.currentIndex,
    required this.chat,
  });
}

class AuthEventGetOutChatFromBodyChatScreen extends AuthEvent {
  const AuthEventGetOutChatFromBodyChatScreen();
}

class AuthEventGetOutChatFromBodyContactScreen extends AuthEvent {
  const AuthEventGetOutChatFromBodyContactScreen();
}
