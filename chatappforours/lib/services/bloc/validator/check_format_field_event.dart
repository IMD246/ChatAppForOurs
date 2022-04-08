import 'package:flutter/material.dart';

@immutable
abstract class CheckFormatFieldEvent {
  final String value;

  const CheckFormatFieldEvent(this.value);
}
class CheckFormatEmailFieldEvent extends CheckFormatFieldEvent{
  const CheckFormatEmailFieldEvent(String value) : super(value);
}
class CheckFormatPasswordFieldEvent extends CheckFormatFieldEvent{
  const CheckFormatPasswordFieldEvent(String value) : super(value);  
}
class CheckFormatFirstNameFieldEvent extends CheckFormatFieldEvent{
  const CheckFormatFirstNameFieldEvent(String value) : super(value);
}
class CheckFormatLastNameFieldEvent extends CheckFormatFieldEvent{
  const CheckFormatLastNameFieldEvent(String value) : super(value);
}
