import 'package:bloc/bloc.dart';
import 'package:chatappforours/services/bloc/theme/theme_event.dart';
import 'package:chatappforours/services/bloc/theme/theme_state.dart';


import 'package:flutter/material.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeStateValid(ThemeMode.light)) {
    on<ChangeDarkModeThemeEvent>(
      (event, emit) {
        event.isOn
            ? emit(const ThemeStateValid(ThemeMode.dark))
            : emit(
                const ThemeStateValid(ThemeMode.light),
              );
      },
    );
  }
}
