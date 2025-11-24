import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/chat/bloc/chat_bloc.dart';
import 'package:home_organizer/features/chat/bloc/chat_event.dart';
import 'package:home_organizer/features/chat/data/message.dart';
import 'package:home_organizer/features/chat/ui/widgets/chat_input.dart';
import 'package:home_organizer/utils/extensions/date_time_format.dart';

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
                  messages
                      .map((message) => _messageCard(context, message))
                      .toList(),
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

  Widget _messageCard(BuildContext context, Message message) {
    final isIncoming = message.incoming;
    final color = isIncoming ? Colors.black : Colors.white;
    final local = message.timestamp.toLocal();
    final time =
        DateTime.now().difference(local) < Duration(days: 1)
            ? local.dayTimeFormat
            : local.dateTimeFormat;
    final labelText =
        isIncoming ? '$time ${message.sender}' : '${message.sender} $time';

    return Align(
      alignment: isIncoming ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color:
              isIncoming
                  ? Theme.of(context).colorScheme.inversePrimary
                  : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment:
              isIncoming ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(message.text, style: TextStyle(color: color)),
            Text(
              labelText,
              style: Theme.of(
                context,
              ).textTheme.labelSmall!.copyWith(color: color.withAlpha(120)),
            ),
          ],
        ),
      ),
    );
  }
}
