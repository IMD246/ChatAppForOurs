import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/models/chat_message.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/view/chat/messageScreen/components/audio_message.dart';
import 'package:chatappforours/view/chat/messageScreen/components/image_message.dart';
import 'package:chatappforours/view/chat/messageScreen/components/text_message.dart';
import 'package:flutter/material.dart';

import '../../../../constants/constants.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    Key? key,
    required this.chatMessage,
    required this.chat,
  }) : super(key: key);
  final ChatMessage chatMessage;
  final Chat chat;
  @override
  Widget build(BuildContext context) {
    Widget messageContaint(ChatMessage chatMessage) {
      switch (chatMessage.messageType) {
        case TypeMessage.text:
          return TextMessage(chatMessage: chatMessage);
        case TypeMessage.audio:
          return AudioMessasge(
            chatMessage: chatMessage,
          );
        case TypeMessage.image:
          return const ImageMesage(
            urlImage: "assets/images/Video Place Here.png",
          );
        default:
          return const SizedBox();
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: kDefaultPadding,
        horizontal: kDefaultPadding * 0.75,
      ),
      child: Row(
        mainAxisAlignment: chatMessage.isSender
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!chatMessage.isSender)
            // CircleAvatar(
            //   backgroundImage: AssetImage(chat.image),
            //   radius: 20,
            // ),
          const SizedBox(width: kDefaultPadding * 0.5),
          messageContaint(chatMessage),
          if (chatMessage.messageStatus != MessageStatus.viewed)
            MessageStatusDot(
              messageStatus: chatMessage.messageStatus,
            ),
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  const MessageStatusDot({Key? key, required, required this.messageStatus})
      : super(key: key);
  final MessageStatus messageStatus;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: kDefaultPadding / 2),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: (messageStatus == MessageStatus.sent ||
                messageStatus == MessageStatus.notViewed ||
                messageStatus == MessageStatus.viewed)
            ? kPrimaryColor
            : Colors.black.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        (messageStatus == MessageStatus.sent ||
                messageStatus == MessageStatus.notViewed ||
                messageStatus == MessageStatus.viewed)
            ? Icons.done
            : null,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
