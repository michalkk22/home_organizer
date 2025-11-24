import 'package:home_organizer/features/expenses/data/models/expenditure.dart';

abstract class ExpensesRepository {
  Future<Expenditure> get(String id);
  Future<Iterable<Expenditure>> getAll();
  Future<Expenditure> add(Expenditure expenditure);
  Future<void> update(Expenditure expenditure);
  Future<void> delete(Expenditure expenditure);
}
