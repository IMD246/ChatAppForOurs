import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/models/ChatMessage.dart';
import 'package:flutter/material.dart';

class AudioMessasge extends StatefulWidget {
  const AudioMessasge({Key? key, required this.chatMessage}) : super(key: key);

  final ChatMessage chatMessage;

  @override
  State<AudioMessasge> createState() => _AudioMessasgeState();
}

class _AudioMessasgeState extends State<AudioMessasge> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding * 0.5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: kPrimaryColor.withOpacity(widget.chatMessage.isSender ? 1 : 0.1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.play_arrow,
            color: widget.chatMessage.isSender ? Colors.white : kPrimaryColor,
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: kPrimaryColor.withOpacity(0.4),
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            "0.37",
            style: TextStyle(
              color: textColorMode(context),
            ),
          ),
        ],
      ),
    );
  }
}
