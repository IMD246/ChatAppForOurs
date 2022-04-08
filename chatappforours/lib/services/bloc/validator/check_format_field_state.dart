import 'package:flutter/foundation.dart';

@immutable
abstract class CheckFormatFieldState{
  final String value;

  const CheckFormatFieldState(this.value);
}
class CheckFormatFieldFirstNameState extends CheckFormatFieldState{
  const CheckFormatFieldFirstNameState(String value) : super(value);
}
class CheckFormatFieldLastNameState extends CheckFormatFieldState{
  const CheckFormatFieldLastNameState(String value) : super(value);
}
class CheckFormatFieldPasswordState extends CheckFormatFieldState{
  const CheckFormatFieldPasswordState(String value) : super(value);
}
class CheckFormatFieldEmailState extends CheckFormatFieldState{
  const CheckFormatFieldEmailState(String value) : super(value);
}
