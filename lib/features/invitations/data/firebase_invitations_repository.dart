import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_organizer/constants/firebase_storage_constants.dart';
import 'package:home_organizer/features/home/data/repositories/homes_repository.dart';
import 'package:home_organizer/features/home/data/repositories/users_repository.dart';
import 'package:home_organizer/features/invitations/data/invitation.dart';
import 'package:home_organizer/features/invitations/data/invitations_repository.dart';
import 'package:home_organizer/features/invitations/domain/invitations_repository_exception.dart';

class FirebaseInvitationsRepository implements InvitationsRepository {
  final String _userId;
  final UsersRepository _usersRepository;
  final HomesRepository _homesRepository;

  FirebaseInvitationsRepository(
    this._userId,
    this._usersRepository,
    this._homesRepository,
  );

  final _invitations = FirebaseFirestore.instance.collection(
    InvitationsCollectionNames.collectionName,
  );

  @override
  Future<void> accept(String id) {
    // TODO: implement accept
    throw UnimplementedError();
  }

  @override
  Future<String> createInvitation() async {
    try {
      final home = await _homesRepository.home;
      if (home == null) {
        throw NotInHomeInvitationsRepositoryException();
      }
      final docRef = await _invitations.add({
        InvitationsCollectionNames.homeIdFieldName: home.id,
        InvitationsCollectionNames.createdByFieldName: _userId,
        InvitationsCollectionNames.expiresAtFieldName: DateTime.timestamp().add(
          Duration(days: 7),
        ),
      });

      final id = docRef.id;

      return 'https://homeorganizer.com/invitations/$id';
    } catch (e) {
      throw CouldNotCreateInvitationsRepositoryException();
    }
  }

  @override
  Future<Invitation> get(String id) async {
    try {
      final doc = await _invitations.doc(id).get();
      final data = doc.data();
      if (data == null) {
        throw NotFoundInvitationsRepositoryException();
      }

      final homeName = await _homesRepository.getName(
        data[InvitationsCollectionNames.homeIdFieldName],
      );
      if (homeName == null) {
        throw HomeNotFoundInvitationsRepositoryException();
      }

      final sender = await _usersRepository.getById(
        data[InvitationsCollectionNames.createdByFieldName],
      );
      if (sender == null || sender.name == null) {
        throw SenderNotFoundInvitationsRepositoryException();
      }

      return Invitation.fromFirebase(
        snapshot: doc,
        homeName: homeName,
        senderName: sender.name!,
      );
    } catch (e) {
      throw NotFoundInvitationsRepositoryException();
    }
  }
}
