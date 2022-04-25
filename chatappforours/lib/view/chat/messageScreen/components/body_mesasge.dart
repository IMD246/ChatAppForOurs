import 'package:chatappforours/models/ChatMessage.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/bloc/message/message_bloc.dart';
import 'package:chatappforours/services/bloc/message/message_state.dart';
import 'package:chatappforours/view/chat/messageScreen/components/chat_input_field_message.dart';
import 'package:chatappforours/view/chat/messageScreen/components/message_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BodyMessage extends StatefulWidget {
  const BodyMessage({Key? key, required this.chat}) : super(key: key);
  final Chat chat;
  @override
  State<BodyMessage> createState() => _BodyMessageState();
}

class _BodyMessageState extends State<BodyMessage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessageBloc(),
      child: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: state.scrollController,
                  itemCount: demeChatMessages.length,
                  itemBuilder: (context, index) {
                    return MessageCard(
                      chatMessage: demeChatMessages[index],
                      chat: widget.chat,
                    );
                  },
                ),
              ),
              const ChatInputFieldMessage(),
            ],
          );
        },
      ),
    );
  }
}
