import 'package:chatappforours/services/auth/auth_exception.dart';
import 'package:chatappforours/services/auth/auth_provider.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider authProvider)
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
        emit(
          const AuthStateLoggedOut(exception: null, isLoading: true),
        );
        final email = event.email;
        final password = event.password;
        try {
          final user =
              await authProvider.logIn(email: email, password: password);
          if (user.isEmailVerified == false) {
            emit(
              AuthStateLoggedOut(
                exception: AuthEmailNeedsVefiricationException(),
                email: user.email,
                isLoading: false,
              ),
            );
          } else {
            emit(
              const AuthStateLoggedOut(exception: null, isLoading: false),
            );
            emit(
              AuthStateLoggedIn(user),
            );
          }
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              exception: e,
              isLoading: false,
            ),
          );
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
        final user = await authProvider.logIn(email: email, password: password);
        if (user.isEmailVerified == false) {
          emit(
            AuthStateRegistering(
              exception: AuthEmailNeedsVefiricationException(),
              email: event.email,
              isLoading: false,
            ),
          );
        }
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
    on<AuthEventSetting>((event, emit) => {emit(const AuthStateSetting())});
  }
}
