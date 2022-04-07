import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/bloc/theme/theme_bloc.dart';
import 'package:chatappforours/services/bloc/theme/theme_event.dart';
import 'package:chatappforours/services/bloc/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BodySetting extends StatefulWidget {
  const BodySetting({Key? key}) : super(key: key);

  @override
  State<BodySetting> createState() => _BodySettingState();
}

class _BodySettingState extends State<BodySetting> {
  late bool isSelectedDarkMode;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        state.themeMode == ThemeMode.light
            ? isSelectedDarkMode = false
            : isSelectedDarkMode = true;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage("assets/images/user_2.png"),
                    ),
                    const SizedBox(height: kDefaultPadding * 0.5),
                    Text(
                      "Nguyễn Thành Duy",
                      style: TextStyle(
                        color: textColorMode(state.themeMode),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        const AssetImage('assets/icons/dakrmode.png'),
                    backgroundColor: textColorMode(state.themeMode),
                  ),
                  const SizedBox(width: kDefaultPadding * 0.5),
                  Text(
                    "Chế độ tối",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColorMode(
                        (state is ThemeStateValid)
                            ? state.themeMode
                            : ThemeMode.light,
                      ),
                    ),
                  ),
                  Switch(
                    inactiveTrackColor: kPrimaryColor.withOpacity(0.5),
                    value: isSelectedDarkMode,
                    activeColor: kPrimaryColor,
                    onChanged: (val) {
                      setState(
                        () {
                          isSelectedDarkMode = val;
                          context.read<ThemeBloc>().add(
                                ChangeDarkModeThemeEvent(val),
                              );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
