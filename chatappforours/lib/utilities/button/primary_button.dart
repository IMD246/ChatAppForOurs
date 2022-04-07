import 'package:chatappforours/services/bloc/theme/theme_bloc.dart';
import 'package:chatappforours/services/bloc/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.text,
    required this.press,
    required this.context,
    this.color = kPrimaryColor,
    this.padding = const EdgeInsets.all(kDefaultPadding * 0.75),
  }) : super(key: key);
  final BuildContext context;
  final String text;
  final VoidCallback press;
  final Color color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
       builder: (context, state) {
        return MaterialButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        padding: padding,
        color: color,
        minWidth: double.infinity,
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            color: textColorMode((state is ThemeStateValid) ? state.themeMode : ThemeMode.light),
          ),
        ),
      );
       },
    );
  }
}
