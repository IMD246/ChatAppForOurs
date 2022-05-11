import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/view/chat/messageScreen/components/chat_input_field_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({
    Key? key,
    required this.firebaseChatMessage,
    required this.id,
    required this.textController,
    required this.widget,
  }) : super(key: key);

  final FirebaseChatMessage firebaseChatMessage;
  final String id;
  final TextEditingController textController;
  final ChatInputFieldMessage widget;

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final String ownerUserID = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        // Map<String, String> map = <String, String>{
        //   idSenderField: widget.id,
        //   messageField: widget.textController.text,
        //   urlImageField: widget.widget.chat.urlUserFriend ?? "",
        // };
        setState(
          () {
            widget.firebaseChatMessage.deleteMessageNotSent(
              ownerUserID: widget.id,
              chatID: widget.widget.chat.idChat,
            );
            widget.firebaseChatMessage.updateTextMessageNotSent(
              chat: widget.widget.chat,
              text: widget.textController.text,
              ownerUserID: widget.id,
            );
            widget.textController.clear();
            if (widget.widget.scroll.isAttached) {
              widget.widget.scroll.jumpTo(
                index: intMaxValue,
              );
            }
          },
        );
        // final chatMessage =
        //     await widget.firebaseChatMessage.getLastMessageOfAChat(
        //   chatID: widget.widget.chat.idChat,
        //   ownerUserID: ownerUserID,
        // );
        // final token = await FirebaseAuth.instance.currentUser!.getIdToken();
        // setState(() {
        //   FirebaseMessaging.instance.getToken(vapidKey: token);
        //   if (widget.widget.chat.listUser.first != widget.id) {
        //     FirebaseMessaging.instance.sendMessage(
        //       messageType: 'chat',
        //       messageId: chatMessage!.idMessage,
        //       data: map,
        //       to: "widget.id",
        //     );
        //   }
        // });
      },
      icon: const Icon(Icons.send),
      color: Theme.of(context).primaryColor,
    );
  }
}
