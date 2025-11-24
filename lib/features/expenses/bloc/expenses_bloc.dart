import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_event.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_state.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure_category.dart';
import 'package:home_organizer/features/expenses/data/repositories/expenditure_categories_repository.dart';
import 'package:home_organizer/features/expenses/data/repositories/expenses_repository.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  StreamSubscription? _expensesSub;
  StreamSubscription? _categoriesSub;

  ExpensesBloc(
    ExpensesRepository expenses,
    ExpenditureCategoriesRepository categories,
  ) : super(ExpensesStateLoading()) {
    on<ExpensesEventLoad>((event, emit) {
      _expensesSub?.cancel();
      _expensesSub = expenses.getExpenses().listen(
        (expenses) => add(_ExpensesEventUpdateExpenses(expenses: expenses)),
      );

      _categoriesSub?.cancel();
      _categoriesSub = categories.getCategories().listen(
        (categories) =>
            add(_ExpensesEventUpdateCategories(categories: categories)),
      );
    });

    on<_ExpensesEventUpdateExpenses>((event, emit) {
      emit(
        ExpensesStateLoaded(
          isLoading: false,
          expenses: event.expenses,
          categories: state.categories,
        ),
      );
    });

    on<_ExpensesEventUpdateCategories>((event, emit) {
      emit(
        ExpensesStateLoaded(
          isLoading: false,
          expenses: state.expenses,
          categories: event.categories,
        ),
      );
    });

    on<ExpensesEventAction>((event, emit) {
      emit(
        ExpensesStateLoaded(
          isLoading: true,
          expenses: state.expenses,
          categories: state.categories,
        ),
      );
      switch (event.action) {
        case ExpensesAction.add:
          expenses.add(event.expenditure);
          break;
        case ExpensesAction.update:
          expenses.update(event.expenditure);
          break;
        case ExpensesAction.delete:
          expenses.delete(event.expenditure);
          break;
      }
    });
  }
}

class _ExpensesEventUpdateExpenses extends ExpensesEvent {
  final Iterable<Expenditure> expenses;

  const _ExpensesEventUpdateExpenses({required this.expenses});
}

class _ExpensesEventUpdateCategories extends ExpensesEvent {
  final Iterable<ExpenditureCategory> categories;

  const _ExpensesEventUpdateCategories({required this.categories});
}
