import 'package:home_organizer/features/expenses/data/models/expenditure_category.dart';

abstract class ExpenditureCategoriesRepository {
  Future<ExpenditureCategory> get(String id);
  Future<Iterable<ExpenditureCategory>> getAll();
  Future<ExpenditureCategory> add(ExpenditureCategory category);
  Future<void> update(ExpenditureCategory category);
  Future<void> delete(ExpenditureCategory category);
  Future<void> copyDefaults();
}
