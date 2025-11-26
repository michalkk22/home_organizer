import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_event.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_state.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure_category.dart';
import 'package:home_organizer/features/expenses/ui/widgets/category_list_tile.dart';
import 'package:home_organizer/widgets/floating_dropdown_text_field.dart';

class CategoriesListView extends StatelessWidget {
  const CategoriesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpensesBloc, ExpensesState>(
      builder: (context, state) {
        final categories = state.categories ?? [];
        return Scaffold(
          appBar: AppBar(title: Text('Expenditure categories')),
          body: FloatingDropdownTextField(
            onAdd:
                (text) => context.read<ExpensesBloc>().add(
                  ExpensesEventCategoryAction(
                    category: ExpenditureCategory(name: text),
                    action: ExpensesAction.add,
                  ),
                ),
            body: ListView.separated(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryListTile(
                  key: ValueKey(category),
                  category: category,
                );
              },
              separatorBuilder:
                  (BuildContext context, int index) => const Divider(height: 2),
            ),
          ),
        );
      },
    );
  }
}
