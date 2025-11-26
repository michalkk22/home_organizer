import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_organizer/constants/firebase_storage_constants.dart';
import 'package:home_organizer/features/shopping/data/shopping_item.dart';
import 'package:home_organizer/features/shopping/data/shopping_repository.dart';
import 'package:home_organizer/features/shopping/domain/shopping_repository_exception.dart';

class FirebaseShoppingRepository implements ShoppingRepository {
  final String _homeId;

  FirebaseShoppingRepository(this._homeId);

  late final _list = FirebaseFirestore.instance
      .collection(HomesCollectionNames.collectionName)
      .doc(_homeId)
      .collection(ShoppingListCollectionNames.collectionName);

  @override
  Future<void> add(ShoppingItem item) async {
    try {
      await _list.add({
        ShoppingListCollectionNames.nameFieldName: item.name,
        ShoppingListCollectionNames.quantityFieldName: item.quantity,
        ShoppingListCollectionNames.unitFieldName: item.unit,
        ShoppingListCollectionNames.inCartFieldName: item.inCart,
      });
    } catch (e) {
      throw CouldNotCreateShoppingRepositoryException();
    }
  }

  @override
  Future<void> delete(ShoppingItem item) async {
    try {
      await _list.doc(item.id).delete();
    } catch (e) {
      throw CouldNotDeleteShoppingRepositoryException();
    }
  }

  @override
  Stream<List<ShoppingItem>> getItems() => _list.snapshots().map(
    (snapshot) =>
        snapshot.docs.map((doc) => ShoppingItem.fromFirebase(doc)).toList(),
  );

  @override
  Future<void> update(ShoppingItem item) async {
    try {
      await _list.doc(item.id).update({
        ShoppingListCollectionNames.nameFieldName: item.name,
        ShoppingListCollectionNames.quantityFieldName: item.quantity,
        ShoppingListCollectionNames.unitFieldName: item.unit,
        ShoppingListCollectionNames.inCartFieldName: item.inCart,
      });
    } catch (e) {
      throw CouldNotDeleteShoppingRepositoryException();
    }
  }
}
