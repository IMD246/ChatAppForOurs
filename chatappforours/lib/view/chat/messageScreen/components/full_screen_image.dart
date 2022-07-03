import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/constants/constants.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatefulWidget {
  const FullScreenImage(
      {Key? key, required this.urlImage, required this.fullName})
      : super(key: key);
  final String urlImage;
  final String fullName;
  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              CachedNetworkImage(
                fit: BoxFit.fill,
                width: size.width,
                height: size.height,
                imageUrl: widget.urlImage,
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Visibility(
                visible: isSelected,
                child: Positioned(
                  top: 5,
                  left: 0,
                  child: Row(
                    children: [
                      const BackButton(
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: kDefaultPadding,
                      ),
                      Text(
                        widget.fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
