import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_event.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure.dart';
import 'package:home_organizer/features/expenses/ui/views/create_update_expenditure_view.dart';
import 'package:home_organizer/features/expenses/ui/views/expenditure_details_view.dart';
import 'package:home_organizer/features/home/bloc/home_bloc.dart';

class ExpensesListView extends StatelessWidget {
  const ExpensesListView({super.key, required this.expenses});
  final List<Expenditure> expenses;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          itemCount: expenses.length,
          itemBuilder: (BuildContext context, int index) {
            final expenditure = expenses[index];
            return _expenditureListTile(context, expenditure);
          },
          separatorBuilder:
              (BuildContext context, int index) => const Divider(height: 2),
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
                        (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: context.read<ExpensesBloc>(),
                            ),
                            BlocProvider.value(value: context.read<HomeBloc>()),
                          ],
                          child: CreateUpdateExpenditureView(
                            action: ExpensesAction.add,
                          ),
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
    final categoryName = expenditure.category?.name ?? '';
    final width = MediaQuery.of(context).size.width;
    return ListTile(
      leading: SizedBox(
        width: width / 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${expenditure.amount}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(' PLN', style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
      title: Text(expenditure.title),
      subtitle: Text(expenditure.user?.name ?? 'deleted user'),
      trailing: SizedBox(
        width: width / 6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('${expenditure.date.month}.${expenditure.date.day}'),
            Text(categoryName),
          ],
        ),
      ),
      onTap:
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: context.read<ExpensesBloc>()),
                      BlocProvider.value(value: context.read<HomeBloc>()),
                    ],
                    child: ExpenditureDetailsView(expenditure: expenditure),
                  ),
            ),
          ),
    );
  }
}
