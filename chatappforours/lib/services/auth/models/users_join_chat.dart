import 'package:chatappforours/constants/user_join_chat_field.dart';
import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersJoinChat {
  final String chatID;
  final String userID;
  final RuleChat ruleChat;
  UsersJoinChat({
    required this.ruleChat,
    required this.chatID,
    required this.userID,
  });
  factory UsersJoinChat.fromSnapshot({
    required QueryDocumentSnapshot<Map<String, dynamic>> docs,
  }) {
    return UsersJoinChat(
        ruleChat: docs
                    .get(ruleChatField)
                    .toString()
                    .compareTo(RuleChat.admin.toString()) ==
                0
            ? RuleChat.admin
            : RuleChat.member,
        chatID: docs.reference.parent.parent!.id,
        userID: docs.get(userIDField));
  }
}
