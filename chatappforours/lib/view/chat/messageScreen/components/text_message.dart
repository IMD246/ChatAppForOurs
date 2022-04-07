import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/models/ChatMessage.dart';
import 'package:chatappforours/services/bloc/theme/theme_bloc.dart';
import 'package:chatappforours/services/bloc/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    required this.chatMessage,
  }) : super(key: key);

  final ChatMessage chatMessage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding * 0.5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: kPrimaryColor.withOpacity(chatMessage.isSender ? 1 : 0.1),
      ),
      child: Text(
        chatMessage.text,
        style: TextStyle(
          color: state.themeMode == ThemeMode.light
              ? textColorMode((state is ThemeStateValid) ? state.themeMode : ThemeMode.light)
                  .withOpacity(chatMessage.isSender ? 0.7 : 1)
              : textColorMode((state is ThemeStateValid) ? state.themeMode : ThemeMode.light),
        ),
      ),
    );
      },
    );
  }
}
