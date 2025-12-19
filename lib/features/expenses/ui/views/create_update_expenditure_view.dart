import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_event.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure_category.dart';
import 'package:home_organizer/features/expenses/ui/views/categories_list_view.dart';
import 'package:home_organizer/features/home/bloc/home_bloc.dart';
import 'package:home_organizer/features/home/data/models/home.dart';
import 'package:home_organizer/features/home/data/models/permissions.dart';
import 'package:home_organizer/features/home/data/models/user.dart';
import 'package:home_organizer/utils/dialogs/error_dialog.dart';
import 'package:home_organizer/widgets/date_picker_button.dart';
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

  late List<ExpenditureCategory> categories;
  late final Home home;
  late final User currentUser;
  late final Permissions permissions;

  late final ValueNotifier<DateTime> _dateController;
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
    permissions = context.read<HomeBloc>().permissions;

    _user = widget.expenditure?.user ?? currentUser;
    _dateController = ValueNotifier(widget.expenditure?.date ?? DateTime.now());
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
          padding: const EdgeInsets.all(10),
          children: [
            FormRow(label: 'Title:', child: TextField(controller: _title)),
            FormRow(
              label: 'User:',
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
              label: 'Amount:',
              child: TextField(
                controller: _amount,
                keyboardType: TextInputType.number,
              ),
            ),
            FormRow(
              label: 'Date:',
              child: DatePickerButton(controller: _dateController),
            ),
            FormRow(
              label: 'Category:',
              child: Row(
                children: [
                  DropdownMenu<ExpenditureCategory?>(
                    initialSelection: widget.expenditure?.category,
                    dropdownMenuEntries:
                        categories
                            .map(
                              (category) =>
                                  DropdownMenuEntry<ExpenditureCategory?>(
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
                  if (permissions.isOwner)
                    IconButton(
                      onPressed: () async {
                        await Navigator.of(context).push(
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
                                  child: CategoriesListView(),
                                ),
                          ),
                        );
                        categories = context.read<ExpensesBloc>().categories;
                      },
                      icon: Icon(Icons.edit),
                    ),
                ],
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
                        date: _dateController.value,
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
