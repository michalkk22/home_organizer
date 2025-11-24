import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_organizer/constants/firebase_storage_constants.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure_category.dart';
import 'package:home_organizer/features/expenses/data/repositories/expenditure_categories_repository.dart';
import 'package:home_organizer/features/expenses/data/repositories/expenses_repository.dart';
import 'package:home_organizer/features/expenses/domain/expenses_repository_exception.dart';
import 'package:home_organizer/features/home/data/repositories/users_repository.dart';

class FirebaseExpensesRepository implements ExpensesRepository {
  final String _homeId;
  final ExpenditureCategoriesRepository _categoriesRepository;
  final UsersRepository _usersRepository;

  FirebaseExpensesRepository(
    this._homeId,
    this._categoriesRepository,
    this._usersRepository,
  );

  late final _expenses = FirebaseFirestore.instance
      .collection(HomesCollectionNames.collectionName)
      .doc(_homeId)
      .collection(ExpensesCollectionNames.collectionName);

  @override
  Future<Expenditure> add(Expenditure expenditure) async {
    try {
      final doc = await _expenses.add({
        ExpensesCollectionNames.userIdFieldName: expenditure.userName,
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

      final category = await _getCategory(data);
      final userName = await _getUserName(data);

      return Expenditure.fromFirebase(
        snapshot: doc,
        category: category,
        userName: userName,
      );
    } catch (e) {
      throw GenericExpensesRepositoryException();
    }
  }

  @override
  Stream<Iterable<Expenditure>> getExpenses() {
    return _expenses
        .orderBy(ExpensesCollectionNames.dateFieldName, descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          List<Expenditure> expenses = [];

          for (var doc in snapshot.docs) {
            final data = doc.data();
            final category = await _getCategory(data);
            final userName = await _getUserName(data);

            expenses.add(
              Expenditure.fromFirebase(
                snapshot: doc,
                category: category,
                userName: userName,
              ),
            );
          }
          return expenses;
        });
  }

  @override
  Future<void> update(Expenditure expenditure) async {
    try {
      if (expenditure.id == null) {
        throw MissingIdExpensesRepositoryException();
      }
      final doc = _expenses.doc(expenditure.id);
      await doc.update({
        ExpensesCollectionNames.userIdFieldName: expenditure.userName,
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

  Future<ExpenditureCategory?> _getCategory(Map<String, dynamic> data) async {
    final categoryId = data[ExpensesCollectionNames.categoryIdFieldName];
    if (categoryId == null) {
      return null;
    }
    return await _categoriesRepository.get(categoryId);
  }

  Future<String?> _getUserName(Map<String, dynamic> data) async {
    final userId = data[ExpensesCollectionNames.userIdFieldName];
    final user = await _usersRepository.getById(userId);
    return user?.name;
  }
}
