
import 'package:chatappforours/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> intialize();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({required String email, required String password});
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailResetPassWord({required String email});
}
