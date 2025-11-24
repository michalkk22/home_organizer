import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_organizer/constants/firebase_storage_constants.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure.dart';
import 'package:home_organizer/features/expenses/data/repositories/expenditure_categories_repository.dart';
import 'package:home_organizer/features/expenses/data/repositories/expenses_repository.dart';
import 'package:home_organizer/features/expenses/domain/expenses_repository_exception.dart';

class FirebaseExpensesRepository implements ExpensesRepository {
  final String _homeId;
  final ExpenditureCategoriesRepository _categoriesRepository;

  FirebaseExpensesRepository(this._homeId, this._categoriesRepository);

  late final _expenses = FirebaseFirestore.instance
      .collection(HomesCollectionNames.collectionName)
      .doc(_homeId)
      .collection(ExpensesCollectionNames.collectionName);

  @override
  Future<Expenditure> add(Expenditure expenditure) async {
    try {
      final doc = await _expenses.add({
        ExpensesCollectionNames.userIdFieldName: expenditure.userId,
        ExpensesCollectionNames.titleFieldName: expenditure.title,
        ExpensesCollectionNames.amountFieldName: expenditure.amount,
        ExpensesCollectionNames.dateFieldName: expenditure.date,
        ExpensesCollectionNames.categoryIdFieldName: expenditure.category?.id,
      });
      return get(doc.id);
    } catch (e) {
      throw CouldNotCreateExpensesRepositoryException();
    }
  }

  @override
  Future<Expenditure> get(String id) async {
    try {
      final doc = await _expenses.doc(id).get();
      final data = doc.data();
      if (data == null) {
        throw CouldNotFindExpensesRepositoryException();
      }

      final categoryId = data[ExpensesCollectionNames.categoryIdFieldName];
      final category =
          categoryId == null
              ? null
              : await _categoriesRepository.get(categoryId);

      return Expenditure.fromFirebase(snapshot: doc, category: category);
    } catch (e) {
      throw GenericExpensesRepositoryException();
    }
  }

  @override
  Future<Iterable<Expenditure>> getAll() async {
    try {
      final snapshot = await _expenses.get();

      List<Expenditure> expenses = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final categoryId = data[ExpensesCollectionNames.categoryIdFieldName];
        final category =
            categoryId == null
                ? null
                : await _categoriesRepository.get(categoryId);
        expenses.add(
          Expenditure.fromFirebase(snapshot: doc, category: category),
        );
      }

      return expenses;
    } catch (e) {
      throw GenericExpensesRepositoryException();
    }
  }

  @override
  Future<void> update(Expenditure expenditure) async {
    try {
      if (expenditure.id == null) {
        throw MissingIdExpensesRepositoryException();
      }
      final doc = _expenses.doc(expenditure.id);
      await doc.update({
        ExpensesCollectionNames.userIdFieldName: expenditure.userId,
        ExpensesCollectionNames.titleFieldName: expenditure.title,
        ExpensesCollectionNames.amountFieldName: expenditure.amount,
        ExpensesCollectionNames.dateFieldName: expenditure.date,
        ExpensesCollectionNames.categoryIdFieldName: expenditure.category?.id,
      });
    } catch (e) {
      throw CouldNotUpdateExpensesRepositoryException();
    }
  }

  @override
  Future<void> delete(Expenditure expenditure) async {
    try {
      if (expenditure.id == null) {
        throw MissingIdExpensesRepositoryException();
      }
      final doc = _expenses.doc(expenditure.id);
      await doc.delete();
    } catch (e) {
      throw CouldNotUpdateExpensesRepositoryException();
    }
  }
}
