import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/features/expenses/data/models/expenditure.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure_category.dart';

@immutable
abstract class ExpensesState {
  final bool isLoading;
  final List<Expenditure>? expenses;
  final List<ExpenditureCategory>? categories;
  final Exception? exception;
  const ExpensesState({
    required this.isLoading,
    this.expenses,
    this.categories,
    this.exception,
  });
}

class ExpensesStateLoading extends ExpensesState {
  const ExpensesStateLoading() : super(isLoading: true);
}

class ExpensesStateLoaded extends ExpensesState {
  const ExpensesStateLoaded({
    required super.isLoading,
    required super.expenses,
    required super.categories,
    super.exception,
  });
}
