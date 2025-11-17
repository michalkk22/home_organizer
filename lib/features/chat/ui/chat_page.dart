import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/chat/bloc/chat_bloc.dart';
import 'package:home_organizer/features/chat/bloc/chat_state.dart';
import 'package:home_organizer/features/chat/ui/chat_view.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatStateRunning) {
          return ChatView(messages: state.messages);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
