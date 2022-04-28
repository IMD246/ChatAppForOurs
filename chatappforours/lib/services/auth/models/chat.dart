import 'package:chatappforours/constants/chat_constant_field.dart';
import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/utilities/time_handle/handle_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String? idChat;
  final String userID;
  final String stampTime;
  final String lastText;
  final String nameChat;
  final TypeChat typeChat;
  RuleChat? rule;
  String? time;
  bool? presence = false;
  String? stampTimeUser;
  Chat({
    required this.userID,
    required this.stampTime,
    required this.lastText,
    required this.nameChat,
    required this.typeChat,
    this.rule,
    this.presence,
    this.time,
    this.stampTimeUser,
    this.idChat,
  });
  factory Chat.fromSnapshot({
    required DocumentSnapshot<Map<String, dynamic>> docs,
    bool? presence,
  }) =>
      Chat(
        idChat: docs.id,
        userID: docs.get(userIDField),
        stampTime: differenceInCalendarDays(
          docs.get(timeLastChatField).toDate(),
        ),
        lastText: docs.get(lastTextField),
        nameChat: docs.get(nameChatField),
        typeChat:
            docs.get(typeChatField).compareTo(TypeChat.normal.toString()) == 0
                ? TypeChat.normal
                : TypeChat.group,
      );
}
