import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_event.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure_category.dart';
import 'package:home_organizer/utils/dialogs/error_dialog.dart';
import 'package:home_organizer/utils/extensions/date_time_format.dart';
import 'package:home_organizer/widgets/form_row.dart';

class CreateUpdateExpenditureView extends StatefulWidget {
  const CreateUpdateExpenditureView({
    super.key,
    required this.action,
    this.expenditure,
    required this.categories,
  });
  final ExpensesAction action;
  final Expenditure? expenditure;
  final Iterable<ExpenditureCategory> categories;

  @override
  State<CreateUpdateExpenditureView> createState() =>
      _CreateUpdateExpenditureViewState();
}

class _CreateUpdateExpenditureViewState
    extends State<CreateUpdateExpenditureView> {
  late final TextEditingController _title;
  late final TextEditingController _amount;
  DateTime _date = DateTime.now();
  ExpenditureCategory? _category;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.expenditure?.title);
    _amount = TextEditingController(text: widget.expenditure?.title);
  }

  @override
  void dispose() {
    super.dispose();
    _title.dispose();
    _amount.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actionText = widget.action == ExpensesAction.add ? 'Add' : 'Update';
    final title = '$actionText expenditure';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            FormRow(label: 'Title', child: TextField(controller: _title)),
            FormRow(
              label: 'Amount: ',
              child: TextField(
                controller: _amount,
                keyboardType: TextInputType.number,
              ),
            ),
            FormRow(
              label: 'Date',
              // TODO: add edit categories button
              child: TextButton(
                onPressed:
                    () async =>
                        _date =
                            await showDatePicker(
                              context: context,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now().add(Duration(days: 356)),
                            ) ??
                            _date,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_date.dateFormat),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            FormRow(
              label: 'Category',
              child: DropdownButton<ExpenditureCategory>(
                items:
                    widget.categories
                        .map(
                          (category) => DropdownMenuItem<ExpenditureCategory>(
                            value: category,
                            child: Text(category.name),
                          ),
                        )
                        .toList()
                      ..add(
                        DropdownMenuItem<ExpenditureCategory>(
                          value: null,
                          child: Text('No category'),
                        ),
                      ),
                onChanged: (value) => _category = value,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  final amount = double.parse(_amount.text);
                  final trimmed = double.parse(amount.toStringAsFixed(2));
                  context.read<ExpensesBloc>().add(
                    ExpensesEventAction(
                      expenditure: Expenditure(
                        id: widget.expenditure?.id,
                        userName: null,
                        userId: widget.expenditure?.userId,
                        title: _title.text,
                        amount: trimmed,
                        date: _date,
                        category: _category,
                      ),
                      action: widget.action,
                    ),
                  );
                  Navigator.of(context).pop();
                } on FormatException catch (_) {
                  showErrorDialog(context, 'Please enter a valid amount');
                }
              },
              child: Text(actionText),
            ),
          ],
        ),
      ),
    );
  }
}
