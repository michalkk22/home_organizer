import 'package:home_organizer/features/chat/data/message.dart';

abstract class ChatRepository {
  Future<void> send(String text);
  Stream<Iterable<Message>> getMessages();
  Future<void> delete(String messageId);
}
