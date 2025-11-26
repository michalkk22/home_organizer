import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_event.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure.dart';
import 'package:home_organizer/features/expenses/ui/views/create_update_expenditure_view.dart';
import 'package:home_organizer/features/home/bloc/home_bloc.dart';
import 'package:home_organizer/utils/dialogs/confirmation_dialog.dart';
import 'package:home_organizer/utils/extensions/date_time_format.dart';
import 'package:home_organizer/widgets/details_row.dart';

class ExpenditureDetailsView extends StatelessWidget {
  const ExpenditureDetailsView({super.key, required this.expenditure});
  final Expenditure expenditure;

  @override
  Widget build(BuildContext context) {
    final user = context.read<HomeBloc>().user;
    final permissions = context.read<HomeBloc>().permissions;

    final isExpenditureOwner = user == expenditure.user;
    final canEdit = permissions.isOwner || isExpenditureOwner;

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
                      text: expenditure.user?.name ?? 'deleted user',
                    ),
                    DetailsRow(
                      label: 'Amount:',
                      text: '${expenditure.amount} PLN',
                    ),
                    DetailsRow(
                      label: 'Date:',
                      text: expenditure.date.dateFormat,
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
                  bottom: 30,
                  right: 15,
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
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text('Delete'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final didEdit = await Navigator.of(
                            context,
                          ).push<bool?>(
                            MaterialPageRoute(
                              builder:
                                  (_) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider.value(
                                        value: context.read<ExpensesBloc>(),
                                      ),
                                      BlocProvider.value(
                                        value: context.read<HomeBloc>(),
                                      ),
                                    ],
                                    child: CreateUpdateExpenditureView(
                                      action: ExpensesAction.update,
                                      expenditure: expenditure,
                                    ),
                                  ),
                            ),
                          );
                          if (didEdit ?? false) {
                            Navigator.of(context).pop();
                          }
                        },
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
