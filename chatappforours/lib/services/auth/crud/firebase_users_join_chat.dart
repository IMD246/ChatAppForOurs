import 'package:chatappforours/constants/chat_constant_field.dart';
import 'package:chatappforours/constants/user_join_chat_field.dart';
import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
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
    };
    final firebaseChat = FirebaseChat();
    await firebaseUsersJoinChat.doc().set(map).whenComplete(() {
       firebaseChat.createChat(
        stampTime: "asd",
        lastText: 'Let make some chat',
        nameChat: fullName,
        typeChat: TypeChat.normal,
        chatID: firebaseUsersJoinChat.doc().path,
      );
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsersJoinChatByID({
    required String userID,
  }) {
    final usersJoinChat = firebaseUsersJoinChat
        .where(userIDField.compareTo(userID) == 0)
        .snapshots();
    return usersJoinChat;
  }
}
