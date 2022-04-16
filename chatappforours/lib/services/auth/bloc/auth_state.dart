import 'package:chatappforours/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser authUser;

  const AuthStateLoggedIn(this.authUser);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLogginFailure extends AuthState {
  final Exception exception;

  const AuthStateLogginFailure(this.exception);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({required this.exception, required this.isLoading});

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  final bool isLoading;
  const AuthStateRegistering(
      {required this.exception, required this.isLoading});
}

class AuthStateLogoutFailure extends AuthState {
  const AuthStateLogoutFailure();
}

class AuthStateSetting extends AuthState {
  const AuthStateSetting();
}
