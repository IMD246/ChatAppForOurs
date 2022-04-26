import 'package:chatappforours/constants/chat_constant_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/utilities/time_handle/handle_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String stampTime;
  final String lastText;
  final String nameChat;
  final TypeChat typeChat;
  final RuleChat? rule;
  final String? userID;
  String? time;
  bool? presence = false;
  Chat(
      {required this.stampTime,
      required this.lastText,
      required this.nameChat,
      required this.typeChat,
      this.rule,
      this.userID,
      this.presence,this.time});
  factory Chat.fromSnapshot({
    required DocumentSnapshot<Map<String, dynamic>> docs,
    required RuleChat rule,
    required String userIDChatScreen,
    bool? presence,
  }) =>
      Chat(
        stampTime: differenceInCalendarDays(
          docs.get(timeLastChatField).toDate(),
        ),
        lastText: docs.get(lastTextField),
        nameChat: docs.get(nameChatField),
        typeChat: docs
                    .get(typeChatField)
                    .toString()
                    .compareTo(TypeChat.normal.toString()) ==
                0
            ? TypeChat.normal
            : TypeChat.group,
        rule: rule,
        userID: userIDChatScreen,
      );
}
