import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/models/chat_message.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/view/chat/messageScreen/components/chat_input_field_message.dart';
import 'package:chatappforours/view/chat/messageScreen/components/message_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  ItemScrollController scrollController = ItemScrollController();
  @override
  void initState() {
    firebaseChatMessage = FirebaseChatMessage();
    setState(() {
      firebaseChatMessage.deleteMessageNotSent(
        ownerUserID: id,
        chatID: widget.chat.idChat,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firebaseChatMessage.getAllMessage(
        chatID: widget.chat.idChat!,
        ownerUserID: id,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allChat = snapshot.data as Iterable<ChatMessage>;
              return Column(
                children: [
                  Expanded(
                    child: ScrollablePositionedList.builder(
                      initialScrollIndex: allChat.length,
                      itemScrollController: scrollController,
                      itemCount: allChat.length,
                      itemBuilder: (context, index) {
                        return MessageCard(
                          chatMessage: allChat.elementAt(index),
                        );
                      },
                    ),
                  ),
                  ChatInputFieldMessage(
                    idChat: widget.chat.idChat!,
                    scroll: scrollController,
                  ),
                ],
              );
            } else {
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
              );
            }
          case ConnectionState.waiting:
            return const Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              ),
            );
          default:
            return const Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }
}
