import 'package:chatappforours/services/bloc/message/message_event.dart';
import 'package:chatappforours/services/bloc/message/message_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc()
      : super(MessageUnvalidState(urlImage: "assets/icons/like_white.png")) {
    on<SendedEventMessage>(
      (event, emit) {
        final value = event.value;
        if (value.isEmpty) {
          emit(
            MessageUnvalidState(urlImage: "assets/icons/like_white.png"),
          );
        } else {
          if (event.isSended) {
            emit(
              MessageValidState(icondata: Icons.send, isSended: true),
            );
          } else {
            emit(
              MessageValidState(icondata: Icons.send, isSended: false),
            );
          }
        }
      },
    );
  }
}
