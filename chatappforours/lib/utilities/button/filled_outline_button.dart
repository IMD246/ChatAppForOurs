import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class FillOutlineButton extends StatelessWidget {
  const FillOutlineButton({
    Key? key,
    this.isFilled = true,
    required this.press,
    this.isCheckAdded = false,
    required this.text,
  }) : super(key: key);

  final bool isFilled;
  final bool isCheckAdded;
  final VoidCallback press;
  final String text;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(color: Colors.white),
      ),
      elevation: !isCheckAdded ? isFilled ? 2 : 0 : 0.5,
      color: isFilled ? Colors.white : Colors.transparent,
      onPressed: press,
      child: Text(
        text,
        style: TextStyle(
          color: isFilled ? kContentColorLightTheme : Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
