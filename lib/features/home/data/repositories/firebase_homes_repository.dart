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
  final String userId;
  final UsersRepository _usersRepository;
  final PermissionsRepository _permissionsRepository;

  FirebaseHomesRepository(
    this.userId,
    this._usersRepository,
    this._permissionsRepository,
  );

  final db = FirebaseFirestore.instance;

  @override
  Future<Home> create(String name) async {
    if (name.length < 4) {
      throw InvalidNameHomesRepositoryException();
    }
    try {
      final batch = db.batch();
      final homeRef = db.collection(HomesCollectionNames.collectionName).doc();
      final inhabitantsRef = homeRef
          .collection(PermissionsCollectionNames.collectionName)
          .doc(userId);

      batch.set(homeRef, {
        HomesCollectionNames.nameFieldName: name,
        HomesCollectionNames.membersFieldName: [userId],
      });
      batch.set(inhabitantsRef, {
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
        await db
            .collection(HomesCollectionNames.collectionName)
            .where(HomesCollectionNames.membersFieldName, arrayContains: userId)
            .get();

    if (homes.docs.isEmpty) {
      return null;
    }
    final homeSnapshot = homes.docs.first;
    final userIds = List<String>.from(
      homeSnapshot.data()[HomesCollectionNames.membersFieldName] ?? [],
    );

    if (userIds.isEmpty) {
      throw CouldNotRetrieveDataHomesRepositoryException();
    }

    Map<User, Permissions?> members = {};
    for (var id in userIds) {
      final user = await _usersRepository.getById(id);
      if (user != null) {
        final permissions = await _permissionsRepository.get(
          homeId: homeSnapshot.id,
          userId: userId,
        );
        members.putIfAbsent(user, () => permissions);
      }
    }

    return Home.fromFirestore(homeSnapshot: homeSnapshot, members: members);
  }
}
