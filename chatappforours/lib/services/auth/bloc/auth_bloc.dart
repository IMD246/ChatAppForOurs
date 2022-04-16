import 'package:chatappforours/services/auth/auth_provider.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/utilities/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider authProvider, BuildContext context)
      : super(const AuthStateLoading()) {
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(
        exception: null,
        isLoading: false,
      ));
    });
    on<AuthEventInitialize>(
      (event, emit) async {
        await authProvider.intialize();
        final user = authProvider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut(null));
        } else {
          emit(AuthStateLoggedIn(user));
        }
      },
    );
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(const AuthStateLoading());
        try {
          final user = await authProvider.logIn(
              email: event.email, password: event.password);
          if (!user.isEmailVerified) {
            showErrorDialog(context, 'Check your gmail to verification');
          } else {
            emit(
              const AuthStateLoggedOut(null),
            );
            emit(AuthStateLoggedIn(user));
          }
        } on Exception catch (e) {
          AuthStateLoggedOut(e);
        }
      },
    );
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await authProvider.createUser(
          email: email,
          password: password,
        );
        await authProvider.sendEmailVerification();
      } on Exception catch (e) {
        emit(AuthStateRegistering(
          exception: e,
          isLoading: false,
        ));
      }
    });
  }
}
