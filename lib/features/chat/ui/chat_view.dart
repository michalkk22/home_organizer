import 'package:flutter/material.dart';
import 'package:home_organizer/features/chat/data/message.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key, required this.messages});

  final Iterable<Message> messages;

  @override
  Widget build(BuildContext context) {
    return Text('ChatView');
  }
}
