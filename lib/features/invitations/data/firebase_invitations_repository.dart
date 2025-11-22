import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_organizer/constants/deeplink_constants.dart';
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

  final _db = FirebaseFirestore.instance;
  final _invitations = FirebaseFirestore.instance.collection(
    InvitationsCollectionNames.collectionName,
  );

  @override
  Future<void> accept(String id) async {
    try {
      final invitationRef = _invitations.doc(id);
      final doc = await invitationRef.get();
      final data = doc.data();

      if (data == null) {
        throw NotFoundInvitationsRepositoryException();
      }

      // check if is not expired
      if (_isExpired(data)) {
        throw ExpiredInvitationsRepositoryException();
      }

      // check if is not already used by this user
      final usedBy =
          data[InvitationsCollectionNames.usedByFieldName] as List<String>;
      if (usedBy.isNotEmpty && usedBy.contains(_userId)) {
        throw UsedUpInvitationsRepositoryException();
      }

      // don't use up invitation wihtout succeding adding user to home
      final batch = _db.batch();

      // set as used by this user to give him permissions for adding himself to home
      batch.update(invitationRef, {
        InvitationsCollectionNames.usedByFieldName: FieldValue.arrayUnion([
          _userId,
        ]),
      });

      // add to home
      final homeId = data[InvitationsCollectionNames.homeIdFieldName];
      await _homesRepository.addMember(homeId, _userId, batch);

      // commit changes
      await batch.commit();
    } catch (_) {
      throw CouldNotAcceptInvitationsRepositoryException();
    }
  }

  @override
  Future<String> createOrGet() async {
    try {
      final home = await _homesRepository.home;
      if (home == null) {
        throw NotInHomeInvitationsRepositoryException();
      }

      var id = await _findCreated(home.id);
      id ??= await _create(home.id);

      return invitationDeepLink + id;
    } catch (e) {
      throw CouldNotCreateInvitationsRepositoryException();
    }
  }

  Future<String?> _findCreated(String homeId) async {
    final snapshot =
        await _invitations
            .where(
              InvitationsCollectionNames.createdByFieldName,
              isEqualTo: _userId,
            )
            .get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    }
    return null;
  }

  Future<String> _create(String homeId) async {
    final docRef = await _invitations.add({
      InvitationsCollectionNames.homeIdFieldName: homeId,
      InvitationsCollectionNames.createdByFieldName: _userId,
      InvitationsCollectionNames.expiresAtFieldName: DateTime.timestamp().add(
        Duration(days: 7),
      ),
      InvitationsCollectionNames.usedByFieldName: [],
    });
    return docRef.id;
  }

  @override
  Future<Invitation> get(String id) async {
    try {
      final doc = await _invitations.doc(id).get();
      final data = doc.data();
      if (data == null) {
        throw NotFoundInvitationsRepositoryException();
      }

      if (_isExpired(data)) {
        throw ExpiredInvitationsRepositoryException();
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

  bool _isExpired(Map<String, dynamic> data) {
    final timestamp =
        data[InvitationsCollectionNames.expiresAtFieldName] as DateTime;
    if (timestamp.isAfter(DateTime.now())) {
      return false;
    }
    return true;
  }
}
