import 'package:chatappforours/constants/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MessageState {
  ItemScrollController scrollController = ItemScrollController();
  MessageState();
}

class MessageValidState extends MessageState {
  final IconData icondata;
  final bool isSended;
  void scroll() {
    scrollController.scrollTo(
      index: intMaxValue,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  MessageValidState({required this.isSended, required this.icondata});
}

class MessageUnvalidState extends MessageState {
  final String urlImage;
  MessageUnvalidState({required this.urlImage}) : super();
}
