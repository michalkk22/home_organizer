import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/chat/bloc/chat_event.dart';
import 'package:home_organizer/features/chat/bloc/chat_state.dart';
import 'package:home_organizer/features/chat/data/chat_repository.dart';
import 'package:home_organizer/features/chat/data/message.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  StreamSubscription? _sub;

  ChatBloc(ChatRepository chat) : super(ChatStateLoading()) {
    on<ChatEventLoad>((event, emit) {
      _sub?.cancel();
      _sub = chat.getMessages().listen(
        (messages) => add(_ChatEventUpdate(messages: messages)),
      );
    });

    on<_ChatEventUpdate>((event, emit) {
      emit(ChatStateRunning(messages: event.messages));
    });

    on<ChatEventSendMessage>((event, emit) {
      chat.send(event.text);
    });
  }
}

class _ChatEventUpdate extends ChatEvent {
  final Iterable<Message> messages;

  const _ChatEventUpdate({required this.messages});
}
