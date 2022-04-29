import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../constants/constants.dart';

class ChatInputFieldMessage extends StatefulWidget {
  const ChatInputFieldMessage({
    Key? key,
    required this.idChat,
    required this.scroll,
  }) : super(key: key);
  final String idChat;
  final ItemScrollController scroll;
  @override
  State<ChatInputFieldMessage> createState() => _ChatInputFieldMessageState();
}

class _ChatInputFieldMessageState extends State<ChatInputFieldMessage> {
  late final TextEditingController textController;
  late final FirebaseChatMessage firebaseChatMessage;
  String id = FirebaseAuth.instance.currentUser!.uid;
  bool isSelected = false;
  bool isTaped = false;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    firebaseChatMessage = FirebaseChatMessage();
    KeyboardVisibilityController().onChange.listen(
      (isVisible) {
        if (isVisible) {
        } else {
          firebaseChatMessage.deleteMessageNotSent(
            ownerUserID: id,
            chatID: widget.idChat,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 32,
            color: const Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.photo),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.mic),
              color: Theme.of(context).primaryColor,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75,
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: kDefaultPadding * 0.4,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        onTap: () => {
                          setState(() {
                            widget.scroll.scrollTo(
                                index: intMaxValue,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          })
                        },
                        onChanged: (value) {
                          setState(() {
                            if (textController.text.isNotEmpty) {
                              firebaseChatMessage.createTextMessageNotSent(
                                userID: id,
                                chatID: widget.idChat,
                              );
                              widget.scroll.scrollTo(
                                  index: intMaxValue,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                            } else {
                              firebaseChatMessage.deleteMessageNotSent(
                                  ownerUserID: id, chatID: widget.idChat);
                            }
                          });
                        },
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'Type Message',
                          hintStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: kDefaultPadding / 4),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.sentiment_satisfied_alt,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
              ),
            ),
            if (textController.text.isNotEmpty)
              IconButton(
                onPressed: () async {
                  await firebaseChatMessage.deleteMessageNotSent(
                    ownerUserID: id,
                    chatID: widget.idChat,
                  );
                  setState(() {
                    textController.clear();
                    firebaseChatMessage.updateTextMessageSent(
                      userID: id,
                      chatID: widget.idChat,
                      text: textController.text,
                    );
                    widget.scroll.scrollTo(
                        index: intMaxValue,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  });
                },
                icon: const Icon(Icons.send),
                color: Theme.of(context).primaryColor,
              ),
            if (textController.text.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding * 0.6),
                child: Image.asset(
                  "assets/icons/like_white.png",
                  color: kPrimaryColor,
                  height: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
