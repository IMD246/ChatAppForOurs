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
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        urlImage,
        height: 20,
        width: 20,
      ),
    );
  }
}
