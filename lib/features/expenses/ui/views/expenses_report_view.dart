import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_bloc.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure_category.dart';
import 'package:home_organizer/features/home/bloc/home_bloc.dart';
import 'package:home_organizer/features/home/data/models/user.dart';
import 'package:home_organizer/utils/extensions/date_time_operations.dart';
import 'package:home_organizer/widgets/date_picker_button.dart';
import 'package:home_organizer/widgets/form_row.dart';

class ExpensesReportView extends StatefulWidget {
  const ExpensesReportView({super.key, required this.allExpenses});
  final List<Expenditure> allExpenses;

  @override
  State<ExpensesReportView> createState() => _ExpensesReportViewState();
}

class _ExpensesReportViewState extends State<ExpensesReportView> {
  final now = DateTime.now();
  late final ValueNotifier<DateTime> _fromDate;
  late final ValueNotifier<DateTime> _toDate;

  final groupByOptions = ['Categories', 'Users'];
  late String groupByValue;

  late List<Expenditure> expenses;
  late List<ExpenditureCategory> categories;
  late List<User> users;

  @override
  void initState() {
    super.initState();

    int year = now.year;
    int month = now.month;
    _fromDate = ValueNotifier(DateTime(year, month));
    if (month == 12) {
      year++;
      month = 0;
    }
    _toDate = ValueNotifier(DateTime(year, month + 1));

    _fromDate.addListener(() => _updateChart());
    _toDate.addListener(() => _updateChart());

    groupByValue = groupByOptions[0];

    categories = context.read<ExpensesBloc>().categories;
    users = context.read<HomeBloc>().home.members.keys.toList();

    _updateChart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expenses report')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DatePickerButton(controller: _fromDate),
                Text('to'),
                DatePickerButton(controller: _toDate),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _addMonth(-1),
                  icon: Icon(Icons.arrow_left),
                ),
                Text('month'),
                IconButton(
                  onPressed: () => _addMonth(1),
                  icon: Icon(Icons.arrow_right),
                ),
              ],
            ),
            FormRow(
              label: 'Group by',
              child: DropdownMenu<String>(
                initialSelection: groupByOptions[0],
                dropdownMenuEntries:
                    groupByOptions
                        .map(
                          (value) => DropdownMenuEntry<String>(
                            value: value,
                            label: value,
                          ),
                        )
                        .toList(),
                onSelected: (value) => _onGoupByChanged(value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onGoupByChanged(String? value) {
    if (value != null) {
      groupByValue = value;
      _updateChart();
    }
  }

  _addMonth(int value) {
    _toDate.value = _toDate.value.addMonth(value: value);
    _fromDate.value = _toDate.value.addMonth(value: value);
    _updateChart();
  }

  _updateChart() {
    expenses =
        widget.allExpenses
            .where(
              (expenditre) =>
                  expenditre.date.isAfter(_fromDate.value) &&
                  expenditre.date.isBefore(_toDate.value),
            )
            .toList();
  }
}
