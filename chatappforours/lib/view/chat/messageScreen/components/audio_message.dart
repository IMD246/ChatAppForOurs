import 'package:audioplayers/audioplayers.dart';
import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/models/chat_message.dart';
import 'package:chatappforours/utilities/handle/handle_value.dart';
import 'package:flutter/material.dart';

class AudioMessasge extends StatefulWidget {
  const AudioMessasge({Key? key, required this.chatMessage}) : super(key: key);

  final ChatMessage chatMessage;

  @override
  State<AudioMessasge> createState() => _AudioMessasgeState();
}

class _AudioMessasgeState extends State<AudioMessasge> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: kPrimaryColor.withOpacity(
          widget.chatMessage.isSender! ? 0.5 : 0.5,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              if (isPlaying) {
                await audioPlayer.pause();
              } else {
                // await audioPlayer.play();
              }
            },
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: widget.chatMessage.isSender != null
                  ? widget.chatMessage.isSender!
                      ? kPrimaryColor
                      : kPrimaryColor.withOpacity(0.5)
                  : kPrimaryColor,
            ),
          ),
          Slider(
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: (value) async {},
          ),
          Text(
            formatTime(position),
            style:
                TextStyle(color: textColorMode(ThemeMode.light), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
