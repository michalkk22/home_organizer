import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_organizer/constants/firebase_storage_constants.dart';
import 'package:home_organizer/features/home/data/models/permissions.dart';
import 'package:home_organizer/features/home/data/repositories/permissions_repository.dart';

class FirebasePermissionsRepository implements PermissionsRepository {
  final db = FirebaseFirestore.instance;

  @override
  Future<Permissions> get({
    required String homeId,
    required String userId,
  }) async {
    final doc =
        await db
            .collection(HomesCollectionNames.collectionName)
            .doc(homeId)
            .collection(PermissionsCollectionNames.collectionName)
            .doc(userId)
            .get();

    return Permissions.fromFirestore(doc);
  }
}
