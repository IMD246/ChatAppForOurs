// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatappforours/enum/enum.dart';
class MessageChat {
  final String userID;
  final String text;
  final TypeMessage typeMessage;
  MessageChat({
    required this.userID,
    required this.text,
    required this.typeMessage,
  });
}