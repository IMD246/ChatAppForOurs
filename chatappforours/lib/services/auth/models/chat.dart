import 'package:chatappforours/constants/chat_constant_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/utilities/time_handle/handle_value.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String idChat;
  final String stampTime;
  final String lastText;
  final String nameChat;
  final TypeChat typeChat;
  String? userID;
  RuleChat? rule;
  String? time;
  bool? presence = false;
  String? stampTimeUserFormated;
  DateTime? stampTimeUser;
  Chat({
    required this.idChat,
    required this.stampTime,
    required this.lastText,
    required this.nameChat,
    required this.typeChat,
    this.userID,
    this.rule,
    this.presence,
    this.time,
    this.stampTimeUser,
    this.stampTimeUserFormated
  });
  factory Chat.fromSnapshot({
    required DocumentSnapshot<Map<String, dynamic>> docs,
    bool? presence,
  }) =>
      Chat(
        idChat: docs.id,
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
