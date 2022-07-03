import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/auth/models/chat_message.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/view/chat/messageScreen/components/chat_input_field_message.dart';
import 'package:chatappforours/view/chat/messageScreen/components/message_card.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';


class BodyMessage extends StatefulWidget {
  const BodyMessage(
      {Key? key, required this.chat, required this.ownerUserProfile})
      : super(key: key);
  final Chat chat;
  final UserProfile ownerUserProfile;
  @override
  State<BodyMessage> createState() => _BodyMessageState();
}

class _BodyMessageState extends State<BodyMessage> {
  late final FirebaseChatMessage firebaseChatMessage;
  late final ItemScrollController scrollController;
  

  @override
  void initState() {
    firebaseChatMessage = FirebaseChatMessage();
    scrollController = ItemScrollController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(
          stream: firebaseChatMessage.getAllMessage(
            chatID: widget.chat.idChat,
            ownerUserID: widget.ownerUserProfile.idUser!,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                if (scrollController.isAttached) {
                  scrollController.scrollTo(
                    index: intMaxValue,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
                final allChatMessage = snapshot.data as Iterable<ChatMessage>;
                return Expanded(
                  child: ScrollablePositionedList.builder(
                    initialScrollIndex: allChatMessage.length,
                    itemScrollController: scrollController,
                    itemCount: allChatMessage.length,
                    itemBuilder: (context, index) {
                      if (index != -1) {
                        if (allChatMessage.elementAt(index).messageStatus ==
                            MessageStatus.notSent) {
                          return Visibility(
                            visible: allChatMessage.elementAt(index).isSender ==
                                false,
                            child: MessageCard(
                              chatMessage: allChatMessage.elementAt(index),
                              listChatMesage: allChatMessage,
                              index: index,
                              beforeIndex: index - 1,
                              chat: widget.chat,
                              scrollController: scrollController, ownerUserProfile: widget.ownerUserProfile,
                            ),
                          );
                        } else {
                          return MessageCard(
                            chatMessage: allChatMessage.elementAt(index),
                            listChatMesage: allChatMessage,
                            index: index,
                            beforeIndex: index - 1,
                            chat: widget.chat,
                            scrollController: scrollController, ownerUserProfile: widget.ownerUserProfile,
                          );
                        }
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
          ownerUserProfile: widget.ownerUserProfile,
          chat: widget.chat,
          scroll: scrollController,
        ),
      ],
    );
  }
}
