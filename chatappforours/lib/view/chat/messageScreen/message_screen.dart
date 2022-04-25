import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/view/chat/messageScreen/components/body_mesasge.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class MesssageScreen extends StatelessWidget {
  const MesssageScreen({Key? key, required this.chat}) : super(key: key);
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(chat, ThemeMode.light, context),
      body: BodyMessage(
        chat: chat,
      ),
    );
  }

  AppBar buildAppbar(Chat chat, ThemeMode themeMode, BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const BackButton(),
          Stack(
            children: [
              // CircleAvatar(
              //   radius: 20,
              //   backgroundImage: AssetImage(chat.image),
              // ),
              if (chat.presence == true)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 16,
                    width: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPrimaryColor,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chat.nameChat,
                style: TextStyle(
                    color: textColorMode(themeMode).withOpacity(0.8),
                    fontSize: 16),
              ),
              Text(
                chat.presence! ? 'Online' : 'Online ${chat.stampTime}',
                style: TextStyle(
                  color: Colors.black.withOpacity(
                    themeMode == ThemeMode.light ? 0.4 : 0.6,
                  ),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.call),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.videocam),
        ),
      ],
    );
  }
}
