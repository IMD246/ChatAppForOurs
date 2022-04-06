import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/models/chat.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:chatappforours/view/chat/chatScreen/components/chat_card.dart';
import 'package:chatappforours/view/chat/messageScreen/message_screen.dart';
import 'package:flutter/material.dart';

class BodyChatScreen extends StatelessWidget {
  const BodyChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: kPrimaryColor,
          padding: const EdgeInsets.fromLTRB(
            kDefaultPadding,
            0,
            kDefaultPadding,
            kDefaultPadding,
          ),
          child: Row(
            children: [
              FillOutlineButton(
                press: () {},
                text: "Recent Message",
                isFilled: true,
              ),
              const SizedBox(width: kDefaultPadding),
              FillOutlineButton(
                press: () {},
                text: "Active",
                isFilled: false,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: chatsData.length,
            itemBuilder: (context, index) {
              return ChatCard(
                chat: chatsData[index],
                press: () async {
                  final chatData = await chatsData[index];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MesssageScreen(chat: chatData);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}