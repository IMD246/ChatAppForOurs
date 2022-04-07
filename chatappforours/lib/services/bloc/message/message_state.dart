import 'package:flutter/widgets.dart';

class MessageState {
  ScrollController scrollController = ScrollController();
  MessageState();
}

class MessageValidState extends MessageState {
  final IconData icondata;
  final bool isSended;
  void scroll() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);
  }

  MessageValidState({required this.isSended, required this.icondata});
}

class MessageUnvalidState extends MessageState {
  final String urlImage;
  MessageUnvalidState({required this.urlImage}) : super();
}
