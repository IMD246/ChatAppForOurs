import 'package:flutter/material.dart';

class ImageMesage extends StatefulWidget {
  const ImageMesage({Key? key, required this.urlImage}) : super(key: key);
  final String urlImage;
  @override
  State<ImageMesage> createState() => _ImageMesageState();
}

class _ImageMesageState extends State<ImageMesage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child: AspectRatio(
        aspectRatio: 1.6,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(widget.urlImage),
        ),
      ),
    );
  }
}
