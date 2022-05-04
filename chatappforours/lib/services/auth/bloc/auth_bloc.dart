import 'package:chatappforours/services/auth/models/auth_exception.dart';
import 'package:chatappforours/services/auth/models/auth_provider.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/firebase_friend_list.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/services/auth/storage/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        emit(const AuthStateLoggedOut(exception: null, isLoading: true));
        FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
        final user = authProvider.currentUser;
        try {
          final userProfile =
              await firebaseUserProfile.getUserProfile(userID: user?.id);
          if (userProfile == null) {
            emit(
              const AuthStateLoggedOut(exception: null, isLoading: false),
            );
          } else {
            if (user != null) {
              if (user.isEmailVerified == true) {
                await firebaseUserProfile.updateUserPresenceDisconnect(
                  uid: user.id!,
                );
                emit(
                  AuthStateLoggedIn(authUser: user, isLoading: false),
                );
              } else {
                await FirebaseAuth.instance.currentUser?.delete();
                emit(
                  const AuthStateLoggedOut(exception: null, isLoading: false),
                );
              }
            } else {
              emit(
                const AuthStateLoggedOut(exception: null, isLoading: false),
              );
            }
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
            FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
            await firebaseUserProfile.updateUserPresenceDisconnect(
              uid: user.id!,
            );
            await firebaseUserProfile.upDateUserIsEmailVerified(
              userID: user.id!,
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
    on<AuthEventRegister>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        final FirebaseFriendList friendListFirebase = FirebaseFriendList();
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
          await friendListFirebase.createNewFriendDefault(
            userIDFriend: user.id!,
            ownerUserID: user.id!,
          );
          await authProvider.sendEmailVerification();
          final userProfileFirebase = FirebaseUserProfile();
          await userProfileFirebase.createUserProfile(
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
      },
    );
    on<AuthEventLogOut>(
      (event, emit) async {
        FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: true,
          ),
        );
        try {
          await firebaseUserProfile.updateUserPresence(
            bool: false,
            uid: authProvider.currentUser?.id,
          );
          final userProfile = await firebaseUserProfile.getUserProfile(
              userID: authProvider.currentUser?.id);
          if (userProfile != null) {
            await authProvider.logOut();
          }
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
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
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
    on<AuthEventSignInWithFacebook>(
      (event, emit) async {
        emit(
          const AuthStateSignInWithFacebook(
            isLoading: true,
            exception: null,
          ),
        );
        Exception? exception;
        try {
          await authProvider.createUserWithFacebook();
          exception = null;
          emit(
            const AuthStateSignInWithFacebook(
              isLoading: false,
              exception: null,
            ),
          );
        } on Exception catch (e) {
          exception = e;
        }
        emit(AuthStateSignInWithFacebook(
          isLoading: false,
          exception: exception,
        ));
      },
    );
    on<AuthEventSignInWithGoogle>(
      (event, emit) async {
        final FirebaseFriendList friendListFirebase = FirebaseFriendList();
        final userProfileFirebase = FirebaseUserProfile();
        emit(
          const AuthStateLoggedOut(
            isLoading: true,
            exception: null,
          ),
        );
        try {
          final user = await authProvider.createUserWithGoogle();
          final getUserProfile =
              await userProfileFirebase.getUserProfile(userID: user.id);
          if (getUserProfile == null) {
            await friendListFirebase.createNewFriendDefault(
              userIDFriend: user.id!,
              ownerUserID: user.id!,
            );
            final userProfile = UserProfile(
              email: user.email!,
              fullName: user.displayName!,
              urlImage: user.photoURL,
              isEmailVerified: true,
              isDarkMode: false,
            );
            await userProfileFirebase.createUserProfile(
              userID: user.id!,
              userProfile: userProfile,
            );
            await userProfileFirebase.updateUserPresenceDisconnect(
              uid: user.id!,
            );
            emit(
              AuthStateLoggedIn(
                authUser: authProvider.currentUser!,
                isLoading: false,
              ),
            );
          } else {
            await userProfileFirebase.updateUserPresenceDisconnect(
              uid: user.id!,
            );
            await userProfileFirebase.upDateUserIsEmailVerified(
              userID: user.id!,
            );
            emit(
              AuthStateLoggedIn(
                authUser: authProvider.currentUser!,
                isLoading: false,
              ),
            );
          }
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              isLoading: false,
              exception: e,
            ),
          );
        }
      },
    );
    on<AuthEventGetInChatFromBodyChatScreen>(
      (event, emit) {
        emit(
          AuthStateGetInChatFromBodyChatScreen(
              chat: event.chat, currentIndex: 0),
        );
      },
    );
    on<AuthEventGetInChatFromBodyContactScreen>(
      (event, emit) {
        emit(AuthStateGetInChatFromBodyContactScreen(
            chat: event.chat, currentIndex: 1));
      },
    );
    on<AuthEventGetOutChatFromBodyChatScreen>(
      (event, emit) {
        emit(const AuthStateGetOutChatFromBodyChatScreen());
      },
    );
    on<AuthEventGetOutChatFromBodyContactScreen>(
      (event, emit) {
        emit(const AuthStateGetOutChatFromBodyContactScreen());
      },
    );
  }
}
