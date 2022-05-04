import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String? id;
  final String? email;
  final bool? isEmailVerified;
  final String? displayName;
  final String? photoURL;
  const AuthUser({this.displayName, this.photoURL, 
      required this.id, required this.email, required this.isEmailVerified});
  factory AuthUser.fromFirebase(User? user) => AuthUser(
        id: user?.uid,
        email: user?.email,
        isEmailVerified: user!.emailVerified ? true : false,
        displayName:  user.displayName!.isEmpty ? "" : user.displayName ,
        photoURL: user.photoURL!.isEmpty ? "" : user.photoURL,
      );
}
