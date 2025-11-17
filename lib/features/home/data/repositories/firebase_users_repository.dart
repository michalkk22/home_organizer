import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_organizer/constants/firebase_storage_constants.dart';
import 'package:home_organizer/features/home/data/models/user.dart';
import 'package:home_organizer/features/home/data/repositories/users_repository.dart';
import 'package:home_organizer/features/home/domain/users_repository_exception.dart';

class FirebaseUsersRepository implements UsersRepository {
  final String _userId;

  FirebaseUsersRepository(this._userId);

  final users = FirebaseFirestore.instance.collection(
    UserCollectionNames.collectionName,
  );
  User? cachedUser;

  @override
  Future<User> setName(String name) async {
    if (name.length < 4) {
      throw InvalidNameUsersRepositoryException();
    }
    cachedUser = null;
    final docRef = users.doc(_userId);
    try {
      await docRef.set({UserCollectionNames.nameFieldName: name});
    } catch (_) {
      throw CouldNotUpdateUsersRepositoryException();
    }

    final user = await _user;
    if (user == null) {
      throw CouldNotRetrieveDataUsersRepositoryException();
    }
    return user;
  }

  @override
  Future<User?> get user async => _user;

  Future<User?> get _user async {
    cachedUser ??= await getById(_userId);
    return cachedUser;
  }

  @override
  Future<User?> getById(String name) async {
    final doc = await users.doc(_userId).get();
    if (doc.data() == null) {
      return null;
    }
    return User.fromFirestore(snapshot: doc);
  }
}
