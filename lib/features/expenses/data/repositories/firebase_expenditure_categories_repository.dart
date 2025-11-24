import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_organizer/constants/firebase_storage_constants.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure_category.dart';
import 'package:home_organizer/features/expenses/data/repositories/expenditure_categories_repository.dart';
import 'package:home_organizer/features/expenses/domain/expenses_repository_exception.dart';

class FirebaseExpenditureCategoriesRepository
    implements ExpenditureCategoriesRepository {
  final String _homeId;

  FirebaseExpenditureCategoriesRepository(this._homeId);

  final _db = FirebaseFirestore.instance;
  late final _categories = _db
      .collection(HomesCollectionNames.collectionName)
      .doc(_homeId)
      .collection(ExpenditureCategoriesCollectionNames.collectionName);

  @override
  Future<ExpenditureCategory> add(String name) async {
    try {
      final category = await _categories.add({
        ExpenditureCategoriesCollectionNames.nameFieldName: name,
      });
      return get(category.id);
    } catch (e) {
      throw GenericExpensesRepositoryException();
    }
  }

  @override
  Future<void> copyDefaults() async {
    try {
      final defaults = _db.collection(
        ExpenditureCategoriesCollectionNames.defaultsCollectionName,
      );

      final snapshot = await defaults.get();
      final batch = _db.batch();
      for (var doc in snapshot.docs) {
        batch.set(_categories.doc(doc.id), doc.data());
      }

      await batch.commit();
    } catch (e) {
      throw GenericExpensesRepositoryException();
    }
  }

  @override
  Future<ExpenditureCategory> get(String id) async {
    try {
      final doc = await _categories.doc(id).get();
      if (doc.data() == null) {
        throw CouldNotFindExpensesRepositoryException();
      }
      return ExpenditureCategory.fromFirebase(snapshot: doc);
    } catch (e) {
      throw GenericExpensesRepositoryException();
    }
  }

  @override
  Future<Iterable<ExpenditureCategory>> getAll() async {
    try {
      final snapshot = await _categories.get();

      List<ExpenditureCategory> categories = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        categories.add(
          ExpenditureCategory(
            id: doc.id,
            name: data[ExpenditureCategoriesCollectionNames.nameFieldName],
          ),
        );
      }

      return categories;
    } catch (e) {
      throw GenericExpensesRepositoryException();
    }
  }

  @override
  Future<void> update(ExpenditureCategory category) async {
    try {
      final doc = _categories.doc(category.id);
      await doc.update({
        ExpenditureCategoriesCollectionNames.nameFieldName: category.name,
      });
    } catch (e) {
      throw CouldNotUpdateExpensesRepositoryException();
    }
  }
}
