import 'package:flutter/material.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_event.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure_category.dart';
import 'package:home_organizer/features/expenses/ui/views/create_update_expenditure_view.dart';
import 'package:home_organizer/features/expenses/ui/views/expenditure_details_view.dart';

class ExpensesListView extends StatelessWidget {
  const ExpensesListView({
    super.key,
    required this.expenses,
    required this.categories,
  });
  final Iterable<Expenditure> expenses;
  final Iterable<ExpenditureCategory> categories;

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
        Positioned(
          bottom: 15,
          right: 15,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            shape: CircleBorder(),
            onPressed:
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => CreateUpdateExpenditureView(
                          action: ExpensesAction.add,
                          categories: categories,
                        ),
                  ),
                ),
            heroTag: 'add_expenditure',
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.primary,
              size: Theme.of(context).iconTheme.size ?? 40,
            ),
          ),
        ),
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
