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

  final _invitations = FirebaseFirestore.instance.collection(
    InvitationsCollectionNames.collectionName,
  );

  @override
  Future<void> accept(Invitation invitation) async {
    try {
      // check if is not expired
      if (invitation.expiresAt.isAfter(DateTime.now())) {
        throw ExpiredInvitationsRepositoryException();
      }

      // check if already used by this user
      if (invitation.usedBy.isNotEmpty) {
        if (invitation.usedBy.contains(_userId)) {
          throw AlreadyUsedInvitationsRepositoryException();
        } else if (invitation.usedBy.length > 4) {
          throw UsedUpInvitationsRepositoryException();
        }
      }

      // cloud function adds to home user who adds himself to usedBy
      final docRef = _invitations.doc(invitation.id);
      await docRef.update({
        InvitationsCollectionNames.usedByFieldName: FieldValue.arrayUnion([
          _userId,
        ]),
      });
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
    // if there are any invitations, return the first not used up or expired yet
    if (snapshot.docs.isNotEmpty) {
      for (var inv in snapshot.docs) {
        final data = inv.data();
        final usedBy = data[InvitationsCollectionNames.usedByFieldName] as List;
        if (!_isExpired(data) && usedBy.length <= 5) {
          return snapshot.docs.first.id;
        }
      }
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

      final homeId = data[InvitationsCollectionNames.homeIdFieldName];
      final homeName = await _homesRepository.getName(homeId);
      if (homeName == null) {
        throw HomeNotFoundInvitationsRepositoryException();
      }

      final senderId = data[InvitationsCollectionNames.createdByFieldName];
      final sender = await _usersRepository.getById(senderId);
      if (sender == null || sender.name == null) {
        throw SenderNotFoundInvitationsRepositoryException();
      }

      return Invitation.fromFirebase(
        snapshot: doc,
        homeName: homeName,
        senderName: sender.name!,
      );
    } catch (e) {
      throw GenericInvitationsRepositoryException();
    }
  }

  bool _isExpired(Map<String, dynamic> data) {
    final timestamp =
        data[InvitationsCollectionNames.expiresAtFieldName] as Timestamp;
    if (timestamp.toDate().isAfter(DateTime.now())) {
      return false;
    }
    return true;
  }
}
