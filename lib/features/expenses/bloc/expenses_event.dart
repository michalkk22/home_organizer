import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/features/expenses/data/models/expenditure.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure_category.dart';

@immutable
abstract class ExpensesEvent {
  const ExpensesEvent();
}

class ExpensesEventLoad extends ExpensesEvent {
  const ExpensesEventLoad();
}

class ExpensesEventAction extends ExpensesEvent {
  final Expenditure expenditure;
  final ExpensesAction action;

  const ExpensesEventAction({required this.expenditure, required this.action});
}

class ExpensesEventCategoryAction extends ExpensesEvent {
  final ExpenditureCategory category;
  final ExpensesAction action;

  const ExpensesEventCategoryAction({
    required this.category,
    required this.action,
  });
}

enum ExpensesAction { add, update, delete }
