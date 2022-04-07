import 'package:flutter/foundation.dart';

@immutable
abstract class CheckFormatFieldState{
  final String value;

  const CheckFormatFieldState(this.value);
}
class CheckFormatFieldNameState extends CheckFormatFieldState{
  const CheckFormatFieldNameState(String value) : super(value);
}
class CheckFormatFieldPasswordState extends CheckFormatFieldState{
  const CheckFormatFieldPasswordState(String value) : super(value);
}
class CheckFormatFieldEmailState extends CheckFormatFieldState{
  const CheckFormatFieldEmailState(String value) : super(value);
}
