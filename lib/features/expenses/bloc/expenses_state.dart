import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/features/expenses/data/models/expenditure.dart';

@immutable
abstract class ExpensesState {
  final bool isLoading;
  const ExpensesState({required this.isLoading});
}

class ExpensesStateLoading extends ExpensesState {
  const ExpensesStateLoading() : super(isLoading: true);
}

class ExpensesStateLoaded extends ExpensesState {
  final Iterable<Expenditure> expenses;

  const ExpensesStateLoaded({required super.isLoading, required this.expenses});
}
