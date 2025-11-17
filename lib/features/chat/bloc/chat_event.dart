import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class ChatEvent {
  const ChatEvent();
}

class ChatEventLoad extends ChatEvent {
  const ChatEventLoad();
}

class ChatEventSendMessage extends ChatEvent {
  final String text;

  const ChatEventSendMessage({required this.text});
}
