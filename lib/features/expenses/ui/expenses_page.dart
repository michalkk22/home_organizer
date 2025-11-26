import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_state.dart';
import 'package:home_organizer/features/expenses/ui/views/expenses_list_view.dart';
import 'package:home_organizer/utils/dialogs/error_dialog.dart';
import 'package:home_organizer/utils/loading/loading_screen.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpensesBloc, ExpensesState>(
      builder: (context, state) {
        if (state is ExpensesStateLoaded) {
          return ExpensesListView(expenses: state.expenses ?? []);
        } else {
          return Container();
        }
      },
      listener: (BuildContext context, ExpensesState state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context);
        } else {
          LoadingScreen().hide();
        }

        if (state.exception != null) {
          // TODO: switch to get text
          showErrorDialog(context, 'error');
        }
      },
    );
  }
}
