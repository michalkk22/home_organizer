import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_event.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure_category.dart';
import 'package:home_organizer/utils/dialogs/confirmation_dialog.dart';

class CategoryListTile extends StatefulWidget {
  const CategoryListTile({super.key, required this.category});
  final ExpenditureCategory category;

  @override
  State<CategoryListTile> createState() => _CategoryListTileState();
}

class _CategoryListTileState extends State<CategoryListTile> {
  late final TextEditingController _controller;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.category.name);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _update() {
    context.read<ExpensesBloc>().add(
      ExpensesEventCategoryAction(
        category: ExpenditureCategory(
          id: widget.category.id,
          name: _controller.text,
        ),
        action: ExpensesAction.update,
      ),
    );
    isUpdating = false;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:
          isUpdating
              ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextField(controller: _controller, autofocus: true),
                  ),
                  IconButton(
                    onPressed: () => _update(),
                    icon: Icon(Icons.check),
                  ),
                ],
              )
              : Text(widget.category.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed:
                () => setState(() {
                  if (isUpdating) {
                    isUpdating = false;
                  } else {
                    isUpdating = true;
                  }
                }),
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              if (await showConfirmationDialog(
                    context,
                    'Are you sure want to delete this category?',
                  ) ??
                  false) {
                context.read<ExpensesBloc>().add(
                  ExpensesEventCategoryAction(
                    category: widget.category,
                    action: ExpensesAction.delete,
                  ),
                );
              }
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
