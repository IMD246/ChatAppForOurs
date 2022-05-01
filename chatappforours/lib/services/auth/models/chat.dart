import 'package:chatappforours/constants/chat_constant_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/utilities/handle/handle_value.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String idChat;
  final String stampTime;
  final String lastText;
  final TypeChat typeChat;
  String? nameChat;
  String? urlUserFriend;
  String? userID;
  RuleChat? rule;
  String? time;
  bool? presence = false;
  String? stampTimeUserFormated;
  DateTime? stampTimeUser;
  List<String> listUser = [];
  Chat({
    required this.idChat,
    required this.stampTime,
    required this.lastText,
    this.nameChat,
    required this.typeChat,
    this.userID,
    this.rule,
    this.presence,
    this.time,
    this.stampTimeUser,
    this.stampTimeUserFormated,
    required this.listUser,
  });
  factory Chat.fromSnapshot({
    required DocumentSnapshot<Map<String, dynamic>> docs,
  }) =>
      Chat(
        idChat: docs.id,
        stampTime: differenceInCalendarDays(
          docs.get(timeLastChatField).toDate(),
        ),
        nameChat: getNameChat(
            typeChat: getTypeChat(value: docs.get(typeChatField).toString()),
            value: docs.get(nameChatField).toString()),
        lastText: docs.get(lastTextField),
        typeChat: getTypeChat(
          value: docs.get(typeChatField).toString(),
        ),
        listUser: List<String>.from(
          docs.get(listUserField) as List,
        ),
      );
}

String? getNameChat({required TypeChat typeChat, required String value}) {
  if (typeChat == TypeChat.group) {
    return value;
  } else {
    return null;
  }
}

TypeChat getTypeChat({required String value}) {
  if (value.toString().compareTo(TypeChat.normal.toString()) == 0) {
    return TypeChat.normal;
  } else {
    return TypeChat.group;
  }
}
