import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/chat/bloc/chat_bloc.dart';
import 'package:home_organizer/features/chat/bloc/chat_event.dart';
import 'package:home_organizer/features/chat/data/message.dart';
import 'package:home_organizer/features/chat/ui/widgets/chat_input.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key, required this.messages});

  final Iterable<Message> messages;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children:
                  messages.map((message) => _messageCard(message)).toList(),
            ),
          ),
          ChatInput(
            callback:
                (String text) => context.read<ChatBloc>().add(
                  ChatEventSendMessage(text: text),
                ),
          ),
        ],
      ),
    );
  }

  Widget _messageCard(Message message) {
    return Card(margin: EdgeInsets.all(2), child: Text(message.text));
  }
}
