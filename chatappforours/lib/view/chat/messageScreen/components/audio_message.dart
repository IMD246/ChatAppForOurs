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
  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    audioPlayer.setSourceUrl(widget.chatMessage.urlAudio);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      audioPlayer.setSourceUrl(widget.chatMessage.urlAudio);
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                await audioPlayer.play(UrlSource(widget.chatMessage.urlAudio));
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
            onChanged: (value) async {
              final position = Duration(
                seconds: value.toInt(),
              );
              await audioPlayer.seek(position);
              await audioPlayer.resume();
            },
          ),
          Text(
            formatTime((duration - position)),
            style:
                TextStyle(color: textColorMode(ThemeMode.light), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
