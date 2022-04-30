import 'package:flutter/material.dart';

class ImageMessage extends StatefulWidget {
  const ImageMessage({Key? key, required this.urlImage}) : super(key: key);
  final String urlImage;
  @override
  State<ImageMessage> createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image(
        image: AssetImage(
          widget.urlImage,
        ),
        fit: BoxFit.fill,
      ),
    );
  }
}
