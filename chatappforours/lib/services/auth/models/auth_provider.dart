import 'package:chatappforours/services/auth/models/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<AuthUser> logIn({required String email, required String password});
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> createUserWithFacebook();
  
  Future<void> createUserWithGoogle();

  Future<void> sendEmailVerification();
  Future<void> logOut();
  Future<void> sendEmailResetPassWord({required String email});
}
