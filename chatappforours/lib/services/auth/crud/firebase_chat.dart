import 'package:chatappforours/constants/chat_constant_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseChat {
  final firebaseChat = FirebaseFirestore.instance.collection('chat');
  Future<void> createChat({
    required String chatID,
    required String lastText,
    required String nameChat,
    required TypeChat typeChat,
  }) async {
    Map<String, dynamic> map = <String, dynamic>{
      timeLastChatField: DateTime.now(),
      lastTextField: lastText,
      nameChatField: nameChat,
      typeChatField: typeChat.toString(),
    };
    await firebaseChat.doc(chatID).set(map);
  }

  Future<Chat> getChatByID({
    required String idChat,
    required RuleChat ruleChat,
    required String userIDChatScreen,
  }) async {
    final chat = await firebaseChat.doc(idChat).get();
    return Chat.fromSnapshot(
      docs: chat,
      rule: ruleChat,
      userIDChatScreen: userIDChatScreen,
    );
  }
}
