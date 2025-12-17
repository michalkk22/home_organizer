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
      await _db.collection(HomesCollectionNames.collectionName).doc().set({
        HomesCollectionNames.nameFieldName: name,
        HomesCollectionNames.membersFieldName: [_userId],
      });
    } on Exception catch (_) {
      throw CouldNotCreateHomesRepositoryException();
    }

    Home? newHome = await home;
    if (newHome == null) {
      throw CouldNotRetrieveDataHomesRepositoryException();
    }

    while (newHome!.members.isEmpty) {
      // TODO: add timeout
      await _permissionsRepository
          .observe(homeId: newHome.id, userId: _userId)
          .first;
      newHome = await home;
      if (newHome == null) {
        throw CouldNotRetrieveDataHomesRepositoryException();
      }
    }
    return newHome;
  }

  @override
  Future<Home?> get home async {
    try {
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
          if (permissions != null) {
            members.putIfAbsent(member, () => permissions);
          }
        }
      }

      return Home.fromFirestore(snapshot: homeSnapshot, members: members);
    } catch (_) {
      throw CouldNotRetrieveDataHomesRepositoryException();
    }
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
}
