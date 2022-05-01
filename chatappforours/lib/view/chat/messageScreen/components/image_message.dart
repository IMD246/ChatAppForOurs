import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/utilities/transparentImage/transparent_image.dart';
import 'package:flutter/material.dart';

class ImageMessage extends StatefulWidget {
  const ImageMessage({Key? key, required this.urlImage}) : super(key: key);
  final String? urlImage;
  @override
  State<ImageMessage> createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: widget.urlImage != null
          ? CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: widget.urlImage!,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              colorBlendMode: BlendMode.softLight,
            )
          : const Image(
              image: AssetImage(
                "assets/images/defaultImage.png",
              ),
              fit: BoxFit.fill,
            ),
    );
  }
}
