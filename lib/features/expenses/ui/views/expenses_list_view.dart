import 'package:flutter/material.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure.dart';
import 'package:home_organizer/features/expenses/ui/views/expenditure_details_view.dart';

class ExpensesListView extends StatelessWidget {
  const ExpensesListView({super.key, required this.expenses});
  final Iterable<Expenditure> expenses;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Expanded(
          child: ListView(
            children:
                expenses
                    .map(
                      (expenditure) =>
                          _expenditureListTile(context, expenditure),
                    )
                    .toList(),
          ),
        ),
        FloatingActionButton(onPressed: () {}, heroTag: 'add_expenditure'),
      ],
    );
  }

  Widget _expenditureListTile(BuildContext context, Expenditure expenditure) {
    return ListTile(
      title: Text(expenditure.title),
      subtitle: Text(expenditure.userName ?? 'deleted user'),
      trailing: Column(
        children: [
          Text('${expenditure.amount}'),
          Text('${expenditure.category?.name}'),
        ],
      ),
      onTap:
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => ExpenditureDetailsView(expenditure: expenditure),
            ),
          ),
    );
  }
}
