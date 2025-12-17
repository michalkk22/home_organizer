import 'package:home_organizer/features/expenses/data/models/expenditure_category.dart';

abstract class ExpenditureCategoriesRepository {
  Future<ExpenditureCategory> get(String id);
  Stream<List<ExpenditureCategory>> getCategories();
  Future<ExpenditureCategory> add(ExpenditureCategory category);
  Future<void> update(ExpenditureCategory category);
  Future<void> delete(ExpenditureCategory category);
}
