import 'package:home_organizer/features/expenses/data/models/expenditure_category.dart';

abstract class ExpenditureCategoriesRepository {
  Future<ExpenditureCategory> get(String id);
  Future<Iterable<ExpenditureCategory>> getAll();
  Future<ExpenditureCategory> add(String name);
  Future<bool> update(ExpenditureCategory category);
  Future<void> copyDefaults();
}
