import 'package:chatappforours/constants/user_join_chat_field.dart';
import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/models/users_join_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUsersJoinChat {
  final firebaseUsersJoinChat =
      FirebaseFirestore.instance.collection('usersJoinChat');
  Future<void> createUsersJoinChat({
    required String userID,
    required RuleChat ruleChat,
    required String fullName,
  }) async {
    Map<String, dynamic> map = <String, dynamic>{
      userIDField: userID,
      ruleChatField: ruleChat.toString(),
      stampTimeField: DateTime.now(),
    };
    await firebaseUsersJoinChat.doc().set(map);
    final firebaseChat = FirebaseChat();
    final firebase = firebaseUsersJoinChat
        .where(
          userIDField,
          isEqualTo: userID,
        )
        .orderBy(stampTimeField, descending: true)
        .limit(1);
    final id = await firebase.get().then((value) => value.docs.first.id);
    await firebaseChat.createChat(
      lastText: 'Let make some chat',
      nameChat: fullName,
      typeChat: TypeChat.normal,
      chatID: id,
    );
  }

  Stream<Iterable<UsersJoinChat>> getUsersJoinChatByID({
    required String userID,
  }){
    final usersJoinChat = firebaseUsersJoinChat
        .where(userIDField, isEqualTo: userID)
        .orderBy(stampTimeField, descending: true)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (docs) {
              return UsersJoinChat.fromSnapshot(docs: docs);
            },
          ),
        );
    return usersJoinChat;
  }
}
