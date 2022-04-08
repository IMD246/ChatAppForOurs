import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialIcon extends StatelessWidget {
  const SocialIcon({
    Key? key,
    required this.urlImage,
  }) : super(key: key);
  final String urlImage;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Colors.black.withOpacity(0.5),
        ),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        urlImage,
        height: 26,
        width: 20,
        color: Colors.blue,
      ),
    );
  }
}
