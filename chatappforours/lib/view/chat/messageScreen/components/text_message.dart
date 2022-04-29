import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/models/chat_message.dart';
import 'package:chatappforours/utilities/time_handle/handle_value.dart';
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
        color: kPrimaryColor.withOpacity(
          chatMessage.isSender != null
              ? chatMessage.isSender!
                  ? 1
                  : 0.3
              : 0.3,
        ),
      ),
      child: Text(
        chatMessage.value.length >= 17
            ? handleStringMessage(chatMessage.value)
            : chatMessage.value,
        softWrap: true,
        style: TextStyle(
          fontSize: chatMessage.hasSender ? 14 : 30,
          color: textColorMode(ThemeMode.light).withOpacity(
            chatMessage.isSender != null
                ? chatMessage.isSender!
                    ? 1
                    : 0.7
                : 0.7,
          ),
        ),
      ),
    );
  }
}
