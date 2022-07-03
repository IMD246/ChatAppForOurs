import 'package:chatappforours/services/auth/crud/user_presence_field.dart';
import 'package:chatappforours/services/auth/models/auth_exception.dart';
import 'package:chatappforours/services/auth/models/user_presence.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../constants/user_join_chat_field.dart';

class FirebaseUserPresence {
  final firebaseUserPresenceCollection =
      FirebaseDatabase.instance.ref('userPresence');
  Future<void> updateUserPresenceDisconnect({required String uid}) async {
    Map<String, dynamic> presenceStatusTrue = {
      presenceField: true,
      stampTimeField: DateTime.now().toString(),
    };
    await firebaseUserPresenceCollection.child(uid).update(
          presenceStatusTrue,
        );
    Map<String, dynamic> presenceStatusFalse = {
      'presence': false,
      stampTimeField: DateTime.now().toString(),
    };
    await firebaseUserPresenceCollection
        .child(uid)
        .onDisconnect()
        .update(presenceStatusFalse);
  }

  Future<void> updateUserPresence(
      {required String? uid, required bool bool}) async {
    Map<String, dynamic> presenceStatusFalse = {
      'presence': bool,
      stampTimeField: DateTime.now().toString(),
    };
    try {
      await firebaseUserPresenceCollection
          .child(uid!)
          .update(presenceStatusFalse);
    } catch (e) {
      throw UserNotLoggedInAuthException();
    }
  }

  Future<UserPresence> getUserPresence({required String userID}) async {
    return await firebaseUserPresenceCollection.child(userID).once().then(
      (event) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        bool isOnline = data['presence'];
        final stampTimeUser = DateTime.tryParse(data['stamp_time'])!;
        return UserPresence(stampTimeUser, isOnline);
      },
    );
  }
}
