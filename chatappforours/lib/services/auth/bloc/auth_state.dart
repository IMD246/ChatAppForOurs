import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final UserProfile userProfile;

  const AuthStateLoggedIn({required bool isLoading, required this.userProfile})
      : super(isLoading: isLoading);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateForgotPassWord extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;

  const AuthStateForgotPassWord(
      {required bool isLoading,
      required this.exception,
      required this.hasSentEmail})
      : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final String? email;
  const AuthStateLoggedOut(
      {required this.exception, required bool isLoading, this.email})
      : super(isLoading: isLoading);

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  final String? email;
  const AuthStateRegistering(
      {required this.exception, required bool isLoading, this.email})
      : super(isLoading: isLoading);
}

class AuthStateSignInWithFacebook extends AuthState {
  final Exception? exception;
  const AuthStateSignInWithFacebook(
      {required this.exception, required bool isLoading})
      : super(isLoading: isLoading);
}
