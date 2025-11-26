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

  List<ExpenditureCategory> categories = [];

  ExpensesBloc(
    ExpensesRepository expensesRepo,
    ExpenditureCategoriesRepository categoriesRepo,
  ) : super(ExpensesStateLoading()) {
    on<ExpensesEventLoad>((event, emit) {
      _expensesSub?.cancel();
      _expensesSub = expensesRepo.getExpenses().listen(
        (expenses) => add(_ExpensesEventUpdateExpenses(expenses: expenses)),
      );

      _categoriesSub?.cancel();
      _categoriesSub = categoriesRepo.getCategories().listen(
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
      categories = event.categories;
      if (categories.isEmpty) {
        categoriesRepo.copyDefaults();
        return;
      }
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
      try {
        switch (event.action) {
          case ExpensesAction.add:
            expensesRepo.add(event.expenditure);
            break;
          case ExpensesAction.update:
            expensesRepo.update(event.expenditure);
            break;
          case ExpensesAction.delete:
            expensesRepo.delete(event.expenditure);
            break;
        }
      } on Exception catch (e) {
        emit(
          ExpensesStateLoaded(
            isLoading: false,
            expenses: state.expenses,
            categories: state.categories,
            exception: e,
          ),
        );
      }
    });

    on<ExpensesEventCategoryAction>((event, emit) {
      emit(
        ExpensesStateLoaded(
          isLoading: true,
          expenses: state.expenses,
          categories: state.categories,
        ),
      );
      try {
        switch (event.action) {
          case ExpensesAction.add:
            categoriesRepo.add(event.category);
            break;
          case ExpensesAction.update:
            categoriesRepo.update(event.category);
            break;
          case ExpensesAction.delete:
            categoriesRepo.delete(event.category);
            break;
        }
      } on Exception catch (e) {
        emit(
          ExpensesStateCategories(
            isLoading: false,
            expenses: state.expenses,
            categories: state.categories,
            exception: e,
          ),
        );
      }
    });
  }
}

class _ExpensesEventUpdateExpenses extends ExpensesEvent {
  final List<Expenditure> expenses;

  const _ExpensesEventUpdateExpenses({required this.expenses});
}

class _ExpensesEventUpdateCategories extends ExpensesEvent {
  final List<ExpenditureCategory> categories;

  const _ExpensesEventUpdateCategories({required this.categories});
}
