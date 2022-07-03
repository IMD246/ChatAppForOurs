import 'package:chatappforours/constants/constants.dart';
import 'package:flutter/material.dart';

class LikeMessage extends StatelessWidget {
  const LikeMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.2,
      height: size.height * 0.05,
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding * 0.5,
      ),
      child: Image.asset(
        "assets/icons/like_white.png",
        fit: BoxFit.fill,
        color: kPrimaryColor,
      ),
    );
  }
}
