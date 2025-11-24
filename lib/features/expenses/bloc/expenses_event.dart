import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/features/expenses/data/models/expenditure.dart';

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

enum ExpensesAction { add, update, delete }
