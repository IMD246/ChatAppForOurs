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
      emit(
        const AuthStateRegistering(
          exception: null,
          isLoading: false,
        ),
      );
    });
    on<AuthEventInitialize>(
      (event, emit) async {
        await authProvider.intialize();
        final user = authProvider.currentUser;
        if (user == null) {
          emit(
            const AuthStateLoggedOut(exception: null, isLoading: false),
          );
        } else {
          if (user.isEmailVerified == true) {
            emit(
              AuthStateLoggedIn(user),
            );
          } else {
            emit(
              const AuthStateLoggedOut(exception: null, isLoading: false),
            );
          }
        }
      },
    );
    on<AuthEventLogIn>(
      (event, emit) async {
        try {
          emit(
            const AuthStateLoading(),
          );
          final user = await authProvider.logIn(
              email: event.email, password: event.password);
          if (user.isEmailVerified == false) {
            showErrorDialog(
                context: context,
                title: 'Verification Email',
                text: "Check gmail ${user.email} to verification your email");
          } else {
            emit(
              const AuthStateLoggedOut(exception: null, isLoading: false),
            );
            emit(
              AuthStateLoggedIn(user),
            );
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
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
    on<AuthEventLogOut>((event, emit) async {
      try {
        await authProvider.logOut();
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
    on<AuthEventSetting>((event, emit) => {
      emit(const AuthStateSetting())
    });
  }
}
