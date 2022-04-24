import 'package:chatappforours/constants/chat_constant_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String stampTime;
  final String lastText;
  final String nameChat;
  final TypeChat typeChat;
  final RuleChat rule;
  Chat({
    required this.stampTime,
    required this.lastText,
    required this.nameChat,
    required this.typeChat,
    required this.rule,
  });
  factory Chat.fromSnapshot({
    required DocumentSnapshot<Map<String, dynamic>> docs,
    required RuleChat rule,
  }) =>
      Chat(
        stampTime: docs.get(timeLastChatField),
        lastText: docs.get(lastTextField),
        nameChat: docs.get(nameChatField),
        typeChat: docs.get(typeChatField), rule: rule,
      );
}
