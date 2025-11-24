import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_event.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_state.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure.dart';
import 'package:home_organizer/features/expenses/data/repositories/expenses_repository.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  StreamSubscription? _sub;

  ExpensesBloc(ExpensesRepository expenses) : super(ExpensesStateLoading()) {
    on<ExpensesEventLoad>((event, emit) {
      _sub?.cancel();
      _sub = expenses.getExpenses().listen(
        (expenses) => add(_ExpensesEventUpdate(expenses: expenses)),
      );
    });

    on<_ExpensesEventUpdate>((event, emit) {
      emit(ExpensesStateLoaded(isLoading: false, expenses: event.expenses));
    });

    on<ExpensesEventAction>((event, emit) {
      if (state is ExpensesStateLoaded) {
        emit(
          ExpensesStateLoaded(
            isLoading: true,
            expenses: (state as ExpensesStateLoaded).expenses,
          ),
        );
      } else {
        emit(ExpensesStateLoading());
      }
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

class _ExpensesEventUpdate extends ExpensesEvent {
  final Iterable<Expenditure> expenses;

  const _ExpensesEventUpdate({required this.expenses});
}
