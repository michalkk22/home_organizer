import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_organizer/constants/firebase_storage_constants.dart';
import 'package:home_organizer/features/chat/data/chat_repository.dart';
import 'package:home_organizer/features/chat/data/message.dart';
import 'package:home_organizer/features/chat/domain/chat_repository_exception.dart';
import 'package:home_organizer/features/home/data/repositories/users_repository.dart';

class FirebaseChatRepository implements ChatRepository {
  final String _userId;
  final String _homeId;
  final UsersRepository _usersRepository;

  FirebaseChatRepository(this._userId, this._homeId, this._usersRepository);

  late final _chat = FirebaseFirestore.instance
      .collection(HomesCollectionNames.collectionName)
      .doc(_homeId)
      .collection(ChatCollectionNames.collectionName);

  @override
  Future<void> send(String text) async {
    try {
      await _chat.add({
        ChatCollectionNames.senderIdFieldName: _userId,
        ChatCollectionNames.textFieldName: text,
        ChatCollectionNames.timestampFieldName: DateTime.timestamp(),
      });
    } catch (e) {
      throw CouldNotSendChatRepositoryException();
    }
  }

  @override
  Future<void> delete(String messageId) async {
    try {
      await _chat.doc(messageId).delete();
    } catch (e) {
      throw CouldNotDeleteChatRepositoryException();
    }
  }

  @override
  Stream<Iterable<Message>> getMessages() {
    return _chat
        .orderBy(ChatCollectionNames.timestampFieldName)
        .limit(10) // TODO: maybe add pagination
        .snapshots()
        .asyncMap((snapshot) async {
          List<Message> messages = [];

          for (var doc in snapshot.docs) {
            final sender = await _usersRepository.getById(
              doc.data()[ChatCollectionNames.senderIdFieldName],
            );

            var name = sender?.name ?? 'deleted user';
            var incoming = sender?.id != _userId;

            messages.add(Message.fromFirebase(name, doc, incoming));
          }
          return messages;
        });
  }
}
