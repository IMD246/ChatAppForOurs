import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/auth_exception.dart';
import 'package:chatappforours/services/auth/auth_provider.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/crud/user_profile.dart';
import 'package:chatappforours/services/auth/storage/storage.dart';
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
              AuthStateLoggedIn(authUser: user, isLoading: false),
            );
          } else {
            emit(
              const AuthStateLoggedOut(exception: null, isLoading: false),
            );
          }
          const AuthStateLoggedOut(exception: null, isLoading: false);
        }
        const AuthStateLoggedOut(exception: null, isLoading: false);
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
          final user = await authProvider.logIn(
            email: email,
            password: password,
          );
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
        await authProvider.sendEmailVerification();
        final userProfileFirebase = FirebaseUserProfile();
        final user = await authProvider.logIn(
          email: email,
          password: password,
        );
        final userProfile = UserProfile(
          email: user.email!,
          fullName: event.fullName,
          urlImage: '',
          isDarkMode: false,
        );
        await userProfileFirebase.createNewNote(
          userID: user.id!,
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
            emit(
              const AuthStateForgotPassWord(
                exception: null,
                hasSentEmail: false,
                isLoading: true,
              ),
            );
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
          AuthStateSetting(
            isLoading: false,
            authUser: authProvider.currentUser!,
          ),
        ),
      },
    );
    on<AuthEventSettingBack>(
      (event, emit) => {
        emit(
          AuthStateLoggedIn(
              isLoading: false, authUser: authProvider.currentUser!),
        ),
      },
    );
    on<AuthEventUploadImage>(
      (event, emit) async {
        {
          emit(
            AuthStateSetting(
              isLoading: true,
              authUser: authProvider.currentUser!,
            ),
          );
          Storage storage = Storage();
          FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
          try {
            await storage.uploadFile(
              filePath: event.path,
              fileName: event.fileName,
              context: event.context,
            );
            final urlProfile = await storage.getDownloadURL(
              fileName: event.fileName,
            );
            await firebaseUserProfile.uploadUserImage(
              userID: authProvider.currentUser!.id,
              urlImage: urlProfile,
            );
            emit(
              AuthStateSetting(
                isLoading: false,
                authUser: authProvider.currentUser!,
              ),
            );
          } on Exception catch (_) {
            emit(
              AuthStateSetting(
                isLoading: false,
                authUser: authProvider.currentUser!,
              ),
            );
          }
          emit(
            AuthStateSetting(
              isLoading: false,
              authUser: authProvider.currentUser!,
            ),
          );
        }
      },
    );
    on<AuthEventUploadStateTheme>(
      (event, emit) async {
        {
          emit(
            AuthStateSetting(
              isLoading: true,
              authUser: authProvider.currentUser!,
            ),
          );
          FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
          try {
            await firebaseUserProfile.uploadDarkTheme(
              userID: authProvider.currentUser!.id,
              isDarkTheme: event.isDarkTheme,
            );
            emit(
              AuthStateSetting(
                isLoading: false,
                authUser: authProvider.currentUser!,
              ),
            );
          } on Exception catch (_) {
            emit(
              AuthStateSetting(
                isLoading: false,
                authUser: authProvider.currentUser!,
              ),
            );
          }
          emit(
            AuthStateSetting(
              isLoading: false,
              authUser: authProvider.currentUser!,
            ),
          );
        }
      },
    );
    on<AuthEventRegisterWithFacebook>(
      (event, emit) async {
        emit(
          const AuthStateRegiseringWithFacebook(
            isLoading: true,
            exception: null,
          ),
        );
        Exception? exception;
        try {
          await authProvider.createUserWithFacebook();
          exception = null;
          emit(
            const AuthStateRegiseringWithFacebook(
              isLoading: false,
              exception: null,
            ),
          );
        } on Exception catch (e) {
          exception = e;
        }
        emit(AuthStateRegiseringWithFacebook(
          isLoading: false,
          exception: exception,
        ));
      },
    );
    on<AuthEventRegisterWithGoogle>(
      (event, emit) async {
        emit(
          const AuthStateRegiseringWithGoogle(
            isLoading: true,
            exception: null,
          ),
        );
        Exception? exception;
        try {
          await authProvider.createUserWithGoogle();
          exception = null;
          emit(
            const AuthStateRegiseringWithGoogle(
              isLoading: false,
              exception: null,
            ),
          );
        } on Exception catch (e) {
          exception = e;
          emit(
            AuthStateRegiseringWithGoogle(
              isLoading: false,
              exception: exception,
            ),
          );
        }
        emit(
          AuthStateRegiseringWithGoogle(
            isLoading: false,
            exception: exception,
          ),
        );
      },
    );
  }
}
