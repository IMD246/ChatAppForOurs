import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/models/chat_message.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/view/chat/messageScreen/components/chat_input_field_message.dart';
import 'package:chatappforours/view/chat/messageScreen/components/message_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class BodyMessage extends StatefulWidget {
  const BodyMessage({Key? key, required this.chat}) : super(key: key);
  final Chat chat;
  @override
  State<BodyMessage> createState() => _BodyMessageState();
}

class _BodyMessageState extends State<BodyMessage> {
  late final FirebaseChatMessage firebaseChatMessage;
  String id = FirebaseAuth.instance.currentUser!.uid;
  late final ItemScrollController scrollController;
  @override
  void initState() {
    firebaseChatMessage = FirebaseChatMessage();
    scrollController = ItemScrollController();
    KeyboardVisibilityController().onChange.listen(
      (isVisible) {
        if (isVisible) {
        } else {
          firebaseChatMessage.deleteMessageNotSent(
            ownerUserID: id,
            chatID: widget.chat.idChat,
          );
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(
          stream: firebaseChatMessage.getAllMessage(
            chatID: widget.chat.idChat,
            ownerUserID: id,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                final allChat = snapshot.data as Iterable<ChatMessage>;
                return Expanded(
                  child: ScrollablePositionedList.builder(
                    initialScrollIndex: allChat.length,
                    itemScrollController: scrollController,
                    itemCount: allChat.length,
                    itemBuilder: (context, index) {
                      if (index != -1) {
                        return MessageCard(
                          chatMessage: allChat.elementAt(index),
                        );
                      } else {
                        return Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        );
                      }
                    },
                  ),
                );
              case ConnectionState.waiting:
                return const SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(),
                );
              default:
                return const SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
        ChatInputFieldMessage(
          idChat: widget.chat.idChat,
          scroll: scrollController,
        ),
      ],
    );
  }
}
