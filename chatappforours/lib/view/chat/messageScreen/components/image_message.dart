import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/models/chat_message.dart';
import 'package:chatappforours/view/chat/messageScreen/components/image_message_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ImageMessage extends StatefulWidget {
  const ImageMessage({Key? key, required this.chatMessage}) : super(key: key);
  final ChatMessage chatMessage;
  @override
  State<ImageMessage> createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage> {
  late final list = widget.chatMessage.listURLImage!;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Directionality(
        textDirection: widget.chatMessage.hasSender == true
            ? widget.chatMessage.isSender!
                ? TextDirection.rtl
                : TextDirection.ltr
            : TextDirection.rtl,
        child: Container(
          padding: list.length > 1
              ? widget.chatMessage.hasSender == true
                  ? widget.chatMessage.isSender!
                      ? const EdgeInsets.only(left: kDefaultPadding * 3)
                      : const EdgeInsets.only(right: kDefaultPadding * 3)
                  : null
              : widget.chatMessage.hasSender == true
                  ? widget.chatMessage.isSender!
                      ? const EdgeInsets.only(left: kDefaultPadding)
                      : const EdgeInsets.only(right: kDefaultPadding)
                  : null,
          child: list.length <= 1
              ? StaggeredGridView.countBuilder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  padding: widget.chatMessage.isSender!
                      ? const EdgeInsets.only(left: 40)
                      : const EdgeInsets.only(right: 40),
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  itemBuilder: (context, index) {
                    return ImageMessageCard(
                      urlImage: list.elementAt(index),
                      chatMessage: widget.chatMessage,
                    );
                  },
                  staggeredTileBuilder: (index) => const StaggeredTile.fit(3),
                )
              : GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return ImageMessageCard(
                      urlImage: list.elementAt(index),
                      chatMessage: widget.chatMessage,
                    );
                  },
                ),
        ),
      ),
    );
  }
}
