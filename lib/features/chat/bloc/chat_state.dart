import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/features/chat/data/message.dart';

@immutable
abstract class ChatState {
  const ChatState();
}

class ChatStateLoading extends ChatState {
  const ChatStateLoading();
}

class ChatStateRunning extends ChatState {
  final Iterable<Message> messages;

  const ChatStateRunning({required this.messages});
}
