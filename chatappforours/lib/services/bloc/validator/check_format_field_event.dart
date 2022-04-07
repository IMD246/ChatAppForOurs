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
class CheckFormatNameFieldEvent extends CheckFormatFieldEvent{
  const CheckFormatNameFieldEvent(String value) : super(value);
}
