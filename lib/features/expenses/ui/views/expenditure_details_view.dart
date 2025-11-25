import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_event.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure.dart';
import 'package:home_organizer/features/expenses/ui/views/create_update_expenditure_view.dart';
import 'package:home_organizer/utils/dialogs/confirmation_dialog.dart';
import 'package:home_organizer/widgets/details_row.dart';

class ExpenditureDetailsView extends StatelessWidget {
  const ExpenditureDetailsView({
    super.key,
    required this.expenditure,
    required this.canEdit,
  });
  final Expenditure expenditure;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(expenditure.title)),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Center(
                child: ListView(
                  children: [
                    DetailsRow(label: 'Title:', text: expenditure.title),
                    DetailsRow(
                      label: 'User:',
                      text: expenditure.userName ?? 'deleted user',
                    ),
                    DetailsRow(
                      label: 'Amount:',
                      text: '${expenditure.amount} PLN',
                    ),
                    DetailsRow(
                      label: 'Category:',
                      text: expenditure.category?.name ?? 'No category',
                    ),
                  ],
                ),
              ),
              if (canEdit)
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (await showConfirmationDialog(
                                context,
                                'Are you sure want to delete this expenditure?',
                              ) ??
                              false) {
                            context.read<ExpensesBloc>().add(
                              ExpensesEventAction(
                                expenditure: expenditure,
                                action: ExpensesAction.delete,
                              ),
                            );
                          }
                        },
                        child: Text('Delete'),
                      ),
                      ElevatedButton(
                        onPressed:
                            () =>
                                () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => BlocProvider.value(
                                          value: context.read<ExpensesBloc>(),
                                          child: CreateUpdateExpenditureView(
                                            action: ExpensesAction.add,
                                          ),
                                        ),
                                  ),
                                ),
                        child: Text('Edit'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
