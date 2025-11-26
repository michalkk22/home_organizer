import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_event.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure_category.dart';
import 'package:home_organizer/features/home/bloc/home_bloc.dart';
import 'package:home_organizer/features/home/data/models/home.dart';
import 'package:home_organizer/features/home/data/models/user.dart';
import 'package:home_organizer/utils/dialogs/error_dialog.dart';
import 'package:home_organizer/utils/extensions/date_time_format.dart';
import 'package:home_organizer/widgets/form_row.dart';

class CreateUpdateExpenditureView extends StatefulWidget {
  const CreateUpdateExpenditureView({
    super.key,
    required this.action,
    this.expenditure,
  });
  final ExpensesAction action;
  final Expenditure? expenditure;

  @override
  State<CreateUpdateExpenditureView> createState() =>
      _CreateUpdateExpenditureViewState();
}

class _CreateUpdateExpenditureViewState
    extends State<CreateUpdateExpenditureView> {
  late final TextEditingController _title;
  late final TextEditingController _amount;

  late final List<ExpenditureCategory> categories;
  late final Home home;
  late final User currentUser;

  late DateTime _date = widget.expenditure?.date ?? DateTime.now();
  ExpenditureCategory? _category;
  User? _user;

  late final actionText =
      widget.action == ExpensesAction.add ? 'Add' : 'Update';
  late final title = '$actionText expenditure';

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.expenditure?.title);
    final amountText =
        widget.expenditure == null ? '' : '${widget.expenditure?.amount}';
    _amount = TextEditingController(text: amountText);

    categories = context.read<ExpensesBloc>().categories;
    home = context.read<HomeBloc>().home;
    currentUser = context.read<HomeBloc>().user;

    _user = widget.expenditure?.user ?? currentUser;
  }

  @override
  void dispose() {
    super.dispose();
    _title.dispose();
    _amount.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              label: 'User',
              child: DropdownMenu<User>(
                initialSelection: _user,
                dropdownMenuEntries:
                    home.members.keys
                        .map(
                          (user) => DropdownMenuEntry<User>(
                            value: user,
                            label: user.name ?? 'deleted user',
                          ),
                        )
                        .toList(),
                onSelected: (user) => _user = user,
              ),
            ),
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
                              initialDate: _date,
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
              child: DropdownMenu<ExpenditureCategory?>(
                dropdownMenuEntries:
                    categories
                        .map(
                          (category) => DropdownMenuEntry<ExpenditureCategory?>(
                            value: category,
                            label: category.name,
                          ),
                        )
                        .toList()
                      ..add(
                        DropdownMenuEntry<ExpenditureCategory?>(
                          value: null,
                          label: 'No category',
                        ),
                      ),
                onSelected: (category) => _category = category,
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
                        user: _user,
                        title: _title.text,
                        amount: trimmed,
                        date: _date,
                        category: _category,
                      ),
                      action: widget.action,
                    ),
                  );
                  Navigator.of(context).pop(true);
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
