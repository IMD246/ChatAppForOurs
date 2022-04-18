import 'package:chatappforours/services/auth/auth_exception.dart';
import 'package:chatappforours/services/auth/auth_provider.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/crud/user_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider authProvider)
      : super(const AuthStateLoading(isLoading: false)) {
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
              AuthStateLoggedIn(authUser: user, isLoading: true),
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
              AuthStateLoggedIn(authUser: user, isLoading: false),
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
         emit(
            const AuthStateRegistering(
              exception: null,
              email: null,
              isLoading: true,
            ),
          );
        await authProvider.createUser(
          email: email,
          password: password,
        );
        final userProfileFirebase = FirebaseUserProfile();
        await authProvider.sendEmailVerification();
        final user = await authProvider.logIn(
          email: email,
          password: password,
        );
        final userProfile = UserProfile(
          email: user.email,
          fullName: event.fullName,
          urlImage: '',
          isDarkMode: false,
        );
        await userProfileFirebase.createNewNote(
          userID: user.id,
          userProfile: userProfile,
        );
        if (user.isEmailVerified == false) {
          emit(
            AuthStateRegistering(
              exception: AuthEmailNeedsVefiricationException(),
              email: event.email,
              isLoading: false,
            ),
          );
        }
        emit(
            AuthStateRegistering(
              exception: AuthEmailNeedsVefiricationException(),
              email: event.email,
              isLoading: false,
            ),
          );
      } on Exception catch (e) {
        emit(AuthStateRegistering(
          exception: e,
          isLoading: false,
        ));
      }
    });
    on<AuthEventLogOut>(
      (event, emit) async {
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
      },
    );
    on<AuthEventForgetPassword>(
      (event, emit) async {
        emit(
          const AuthStateForgotPassWord(
            exception: null,
            hasSentEmail: false,
            isLoading: false,
          ),
        );
        // user wants to actually send a forgot-password email
        emit(
          const AuthStateForgotPassWord(
            exception: null,
            hasSentEmail: false,
            isLoading: true,
          ),
        );
        bool didSendEmail = false;
        Exception? exception;
        final email = event.email;
        if (email == null) {
          return;
        } else {
          try {
            await authProvider.sendEmailResetPassWord(email: event.email!);
            didSendEmail = true;
            exception = null;
          } on Exception catch (e) {
            didSendEmail = false;
            exception = e;
          }
        }
        emit(
          AuthStateForgotPassWord(
            exception: exception,
            hasSentEmail: didSendEmail,
            isLoading: false,
          ),
        );
      },
    );
    on<AuthEventSetting>(
      (event, emit) => {
        emit(
          const AuthStateSetting(isLoading: false),
        ),
      },
    );
  }
}
