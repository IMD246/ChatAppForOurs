import 'package:chatappforours/enum/enum.dart';

class ChatMessage {
  final String value;
  final TypeMessage messageType;
  final MessageStatus messageStatus;
  final bool isSender;

  ChatMessage({
    this.value = '',
    required this.messageType,
    required this.messageStatus,
    required this.isSender,
  });
}

List demeChatMessages = [
  ChatMessage(
    value: "Hi Sajol,",
    messageType: TypeMessage.text,
    messageStatus: MessageStatus.viewed,
    isSender: false,
  ),
  ChatMessage(
    value: "Hello, How are you?",
    messageType: TypeMessage.text,
    messageStatus: MessageStatus.viewed,
    isSender: true,
  ),
  ChatMessage(
    value: "",
    messageType: TypeMessage.audio,
    messageStatus: MessageStatus.viewed,
    isSender: false,
  ),
  ChatMessage(
    value: "",
    messageType: TypeMessage.image,
    messageStatus: MessageStatus.viewed,
    isSender: true,
  ),
  ChatMessage(
    value: "Error happend",
    messageType: TypeMessage.text,
    messageStatus: MessageStatus.notSent,
    isSender: true,
  ),
  ChatMessage(
    value: "This looks great man!!",
    messageType: TypeMessage.text,
    messageStatus: MessageStatus.viewed,
    isSender: false,
  ),
  ChatMessage(
    value: "Glad you like it",
    messageType: TypeMessage.text,
    messageStatus: MessageStatus.notSent,
    isSender: true,
  ),
  ChatMessage(
    value: "Glad you like it",
    messageType: TypeMessage.text,
    messageStatus: MessageStatus.notSent,
    isSender: true,
  ),
];
