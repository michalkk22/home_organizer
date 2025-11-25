import 'package:home_organizer/features/expenses/data/models/expenditure.dart';

abstract class ExpensesRepository {
  Future<Expenditure> get(String id);
  Stream<List<Expenditure>> getExpenses();
  Future<Expenditure> add(Expenditure expenditure);
  Future<void> update(Expenditure expenditure);
  Future<void> delete(Expenditure expenditure);
}
