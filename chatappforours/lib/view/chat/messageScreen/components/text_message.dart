import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/models/chat_message.dart';
import 'package:flutter/material.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    required this.chatMessage,
  }) : super(key: key);

  final ChatMessage chatMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding * 0.5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: kPrimaryColor.withOpacity(chatMessage.isSender ? 1 : 0.1),
      ),
      child: Text(
        chatMessage.value,
        style: TextStyle(
            color: textColorMode(ThemeMode.light)
                .withOpacity(chatMessage.isSender ? 0.7 : 1),),
      ),
    );
  }
}
