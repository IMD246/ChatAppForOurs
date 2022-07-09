import 'package:chatappforours/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

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
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            color: Colors.black,
            child: Stack(
              children: [
                Center(
                  child: PhotoView(
                    imageProvider: Image.network(
                      widget.urlImage,
                      fit: BoxFit.fill,
                    ).image,
                  ),
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
      ),
    );
  }
}
