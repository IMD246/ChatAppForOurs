abstract class MessageEvent {
  final String value;
  bool isSended = false;
  MessageEvent(this.value, this.isSended);
}

class SendedEventMessage extends MessageEvent {
  SendedEventMessage(String value, bool isSended) : super(value, isSended);
}
