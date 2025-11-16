import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_organizer/features/home/data/repositories/users_storage_constants.dart';
import 'package:home_organizer/features/home/data/models/user.dart';
import 'package:home_organizer/features/home/data/repositories/users_repository.dart';
import 'package:home_organizer/features/home/domain/users_repository_exceptions.dart';

class FirebaseUsersRepository implements UsersRepository {
  late final String userId;

  FirebaseUsersRepository({required this.userId});

  final users = FirebaseFirestore.instance.collection(usersCollectionName);
  User? cachedUser;

  @override
  Future<User> setName(String name) async {
    cachedUser = null;
    final docRef = users.doc(userId);
    try {
      await docRef.set({nameFieldName: name});
    } catch (_) {
      throw CouldNotUpdateUsersRepositoryException();
    }
    return _user;
  }

  @override
  Future<User> get() async => _user;

  Future<User> get _user async {
    if (cachedUser == null) {
      final doc = await users.doc(userId).get();
      if (doc.data() == null) {
        throw NoDataUsersRepositoryException();
      }
      cachedUser = User.fromFirebase(doc.id, doc.data()!);
    }
    return cachedUser!;
  }
}
