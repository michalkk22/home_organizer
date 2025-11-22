import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_organizer/constants/firebase_storage_constants.dart';
import 'package:home_organizer/features/home/data/models/home.dart';
import 'package:home_organizer/features/home/data/models/permissions.dart';
import 'package:home_organizer/features/home/data/models/user.dart';
import 'package:home_organizer/features/home/data/repositories/homes_repository.dart';
import 'package:home_organizer/features/home/data/repositories/permissions_repository.dart';
import 'package:home_organizer/features/home/data/repositories/users_repository.dart';
import 'package:home_organizer/features/home/domain/homes_repository_exception.dart';

class FirebaseHomesRepository implements HomesRepository {
  final String _userId;
  final UsersRepository _usersRepository;
  final PermissionsRepository _permissionsRepository;

  FirebaseHomesRepository(
    this._userId,
    this._usersRepository,
    this._permissionsRepository,
  );

  final _db = FirebaseFirestore.instance;

  @override
  Future<Home> create(String name) async {
    if (name.length < 4) {
      throw InvalidNameHomesRepositoryException();
    }
    try {
      final batch = _db.batch();
      final homeRef = _db.collection(HomesCollectionNames.collectionName).doc();
      final permissionsRef = homeRef
          .collection(PermissionsCollectionNames.collectionName)
          .doc(_userId);

      batch.set(homeRef, {
        HomesCollectionNames.nameFieldName: name,
        HomesCollectionNames.membersFieldName: [_userId],
      });
      batch.set(permissionsRef, {
        PermissionsCollectionNames.isOwnerFieldName: true,
      });

      await batch.commit();
    } on Exception catch (_) {
      throw CouldNotCreateHomesRepositoryException();
    }

    Home? newHome = await home;
    if (newHome == null) {
      throw CouldNotRetrieveDataHomesRepositoryException();
    }
    return newHome;
  }

  @override
  Future<Home?> get home async {
    final homes =
        await _db
            .collection(HomesCollectionNames.collectionName)
            .where(
              HomesCollectionNames.membersFieldName,
              arrayContains: _userId,
            )
            .get();

    if (homes.docs.isEmpty) {
      return null;
    }
    final homeSnapshot = homes.docs.first;
    final memberIds = List<String>.from(
      homeSnapshot.data()[HomesCollectionNames.membersFieldName] ?? [],
    );

    if (memberIds.isEmpty) {
      throw CouldNotRetrieveDataHomesRepositoryException();
    }

    Map<User, Permissions> members = {};
    for (var id in memberIds) {
      final member = await _usersRepository.getById(id);
      if (member != null) {
        final permissions = await _permissionsRepository.get(
          homeId: homeSnapshot.id,
          userId: id,
        );
        members.putIfAbsent(member, () => permissions);
      }
    }

    return Home.fromFirestore(snapshot: homeSnapshot, members: members);
  }

  @override
  Future<String?> getName(String id) async {
    try {
      final home =
          await _db
              .collection(HomesCollectionNames.collectionName)
              .doc(id)
              .get();
      final homeName = home.data()?[HomesCollectionNames.nameFieldName];
      return homeName;
    } catch (e) {
      throw CouldNotRetrieveDataHomesRepositoryException();
    }
  }

  @override
  Future<void> addMember(String homeId, String userId, WriteBatch batch) async {
    try {
      final homeRef = _db
          .collection(HomesCollectionNames.collectionName)
          .doc(homeId);

      final permissionsRef = homeRef
          .collection(PermissionsCollectionNames.collectionName)
          .doc(userId);

      // add user to members
      batch.update(homeRef, {
        HomesCollectionNames.membersFieldName: FieldValue.arrayUnion([userId]),
      });

      // set permissions
      batch.set(permissionsRef, {
        PermissionsCollectionNames.isOwnerFieldName: false,
      });
    } catch (_) {
      throw CouldNotAddMemberHomesRepositoryException();
    }
  }
}
