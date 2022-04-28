import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/bloc/message/message_bloc.dart';
import 'package:chatappforours/services/bloc/message/message_event.dart';
import 'package:chatappforours/services/bloc/message/message_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/constants.dart';

class ChatInputFieldMessage extends StatefulWidget {
  const ChatInputFieldMessage({
    Key? key,
    required this.idChat,
  }) : super(key: key);
  final String idChat;
  @override
  State<ChatInputFieldMessage> createState() => _ChatInputFieldMessageState();
}

class _ChatInputFieldMessageState extends State<ChatInputFieldMessage> {
  late final TextEditingController textController;
  late final FirebaseChatMessage firebaseChatMessage;
  String id = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    textController = TextEditingController();
    firebaseChatMessage = FirebaseChatMessage();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBloc, MessageState>(
      builder: (context, state) {
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
                            onTap: () async => {
                              await firebaseChatMessage
                                  .createTextMessageNotSent(
                                userID: id,
                                chatID: widget.idChat,
                              )
                            },
                            minLines: 1,
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            onChanged: (value) async {
                              if (value.isEmpty) {
                                await firebaseChatMessage.deleteMessageNotSent(
                                  ownerUserID: id,
                                  chatID: widget.idChat,
                                );
                              }
                              context.read<MessageBloc>().add(
                                    SendedEventMessage(value, false),
                                  );
                            },
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
                if (state is MessageValidState)
                  IconButton(
                    onPressed: () {
                      context.read<MessageBloc>().add(
                            SendedEventMessage(textController.text, true),
                          );
                      textController.clear();
                      context.read<MessageBloc>().add(
                            SendedEventMessage(textController.text, true),
                          );
                      state.scroll();
                    },
                    icon: Icon(state.icondata),
                    color: Theme.of(context).primaryColor,
                  ),
                if (state is MessageUnvalidState)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding * 0.6),
                    child: Image.asset(
                      state.urlImage,
                      color: kPrimaryColor,
                      height: 24,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
