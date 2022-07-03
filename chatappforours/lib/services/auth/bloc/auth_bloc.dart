import 'dart:io';

import 'package:chatappforours/services/auth/models/auth_exception.dart';
import 'package:chatappforours/services/auth/models/auth_provider.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider authProvider)
      : super(
          const AuthStateLoading(
            isLoading: false,
          ),
        ) {
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
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: true,
          ),
        );

        FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
        final user = authProvider.currentUser;
        try {
          final userProfile =
              await firebaseUserProfile.getUserProfile(userID: user?.id);
          if (userProfile == null && user == null) {
            emit(
              const AuthStateLoggedOut(exception: null, isLoading: false),
            );
          } else if (user != null && userProfile != null) {
            if (user.isEmailVerified == true) {
              await firebaseUserProfile.updateUserPresenceDisconnect(
                  uid: user.id!);
              emit(
                AuthStateLoggedIn(userProfile: userProfile, isLoading: false),
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
            final getUserProfile =
                await firebaseUserProfile.getUserProfile(userID: user.id);

            await firebaseUserProfile.updateUserIsEmailVerified(
              userID: user.id!,
            );
            emit(
              AuthStateLoggedIn(userProfile: getUserProfile!, isLoading: false),
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
          final token = await FirebaseAuth.instance.currentUser!.getIdToken();
          final userProfile = UserProfile(
            email: user.email!,
            fullName: event.fullName,
            urlImage: '',
            isDarkMode: false,
            isEmailVerified: false,
            language: Platform.localeName.substring(0, 2).toString(),
            tokenUser: token,
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
          } else {
            await userProfileFirebase.updateUserIsEmailVerified(
                userID: user.id!);
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
          if (authProvider.currentUser?.id != null) {
            await authProvider.logOut();
          }
          await FirebaseFirestore.instance.clearPersistence();
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

    on<AuthEventSignInWithFacebook>(
      (event, emit) async {
        // final FirebaseFriendList friendListFirebase = FirebaseFriendList();
        // final userProfileFirebase = FirebaseUserProfile();
        emit(
          const AuthStateLoggedOut(
            isLoading: true,
            exception: null,
          ),
        );
        // try {
        //   final user = await authProvider.createUserWithFacebook();
        //   if (user.email != null) {
        //     final getUserProfile = await userProfileFirebase
        //         .getUserProfileByEmail(email: user.email);
        //     if (getUserProfile == null) {
        //       await friendListFirebase.createNewFriendDefault(
        //         userIDFriend: user.id!,
        //         ownerUserID: user.id!,
        //       );
        //       final userProfile = UserProfile(
        //         email: user.email!,
        //         fullName: user.displayName!,
        //         urlImage: user.photoURL,
        //         isEmailVerified: true,
        //         isDarkMode: false,
        //       );
        //       await userProfileFirebase.createUserProfile(
        //         userID: user.id!,
        //         userProfile: userProfile,
        //       );
        //       await userProfileFirebase.updateUserPresenceDisconnect(
        //         uid: user.id!,
        //       );
        //       emit(
        //         AuthStateLoggedIn(
        //           userProfile: getUserProfile!,
        //           isLoading: false,
        //         ),
        //       );
        //     } else {
        //       await userProfileFirebase.uploadIsSignInWithFacebookOrGoogle(
        //         userID: user.id!,
        //         isSignInWithFacebookOrGoogle: true,
        //       );
        //       await userProfileFirebase.updateUserPresenceDisconnect(
        //         uid: user.id!,
        //       );
        //       await userProfileFirebase.upDateUserIsEmailVerified(
        //         userID: user.id!,
        //       );
        //       emit(
        //         AuthStateLoggedIn(
        //           userProfile: getUserProfile,
        //           isLoading: false,
        //         ),
        //       );
        //     }
        //   } else {
        //     emit(
        //       AuthStateLoggedOut(
        //         isLoading: false,
        //         exception: UserNotFoundAuthException(),
        //       ),
        //     );
        //   }
        // } on Exception catch (e) {
        //   emit(
        //     AuthStateLoggedOut(
        //       isLoading: false,
        //       exception: e,
        //     ),
        //   );
        // }
      },
    );
    on<AuthEventSignInWithGoogle>(
      (event, emit) async {
        final userProfileFirebase = FirebaseUserProfile();
        final user = await authProvider.createUserWithGoogle();
        emit(
          const AuthStateLoggedOut(
            isLoading: true,
            exception: null,
          ),
        );
        try {
          if (user.email != null) {
            final getUserProfileVerify = await userProfileFirebase
                .getUserProfileByEmail(email: user.email);
            if (getUserProfileVerify == null) {
              final token =
                  await FirebaseAuth.instance.currentUser!.getIdToken();
              final userProfile = UserProfile(
                email: user.email!,
                fullName: user.displayName!,
                urlImage: user.photoURL!,
                isEmailVerified: true,
                isDarkMode: false,
                language: Platform.localeName.substring(0, 2).toString(),
                tokenUser: token,
              );
              await userProfileFirebase.createUserProfile(
                userID: user.id!,
                userProfile: userProfile,
              );
              final getUserProfile =
                  await userProfileFirebase.getUserProfile(userID: user.id);
              emit(
                AuthStateLoggedIn(
                  userProfile: getUserProfile!,
                  isLoading: false,
                ),
              );
            } else {
              emit(
                AuthStateLoggedIn(
                  userProfile: getUserProfileVerify,
                  isLoading: false,
                ),
              );
            }
          } else {
            emit(
              AuthStateLoggedOut(
                isLoading: false,
                exception: UserNotFoundAuthException(),
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
  }
}
