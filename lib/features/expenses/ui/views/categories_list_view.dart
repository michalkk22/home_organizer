import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_bloc.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_event.dart';
import 'package:home_organizer/features/expenses/bloc/expenses_state.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure_category.dart';
import 'package:home_organizer/features/expenses/ui/widgets/category_list_tile.dart';

class CategoriesListView extends StatefulWidget {
  const CategoriesListView({super.key});

  @override
  State<CategoriesListView> createState() => _CategoriesListViewState();
}

class _CategoriesListViewState extends State<CategoriesListView> {
  late final TextEditingController _controller;
  bool addFieldVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _hideButtonFunction() {
    setState(() {
      addFieldVisible = false;
    });
  }

  void _addButtonFunction(BuildContext context) {
    setState(() {
      if (addFieldVisible) {
        context.read<ExpensesBloc>().add(
          ExpensesEventCategoryAction(
            category: ExpenditureCategory(name: _controller.text),
            action: ExpensesAction.add,
          ),
        );
        _controller.clear();
        addFieldVisible = false;
      } else {
        addFieldVisible = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpensesBloc, ExpensesState>(
      builder: (context, state) {
        final categories = state.categories ?? [];
        return Scaffold(
          appBar: AppBar(title: Text('Expenditure categories')),
          body: Stack(
            children: [
              ListView.separated(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryListTile(
                    key: ValueKey(category),
                    category: category,
                  );
                },
                separatorBuilder:
                    (BuildContext context, int index) =>
                        const Divider(height: 2),
              ),
              Positioned(
                bottom: 15,
                right: 15,
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  shape: CircleBorder(),
                  onPressed: () => _addButtonFunction(context),
                  heroTag: 'add_category',
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.primary,
                    size: Theme.of(context).iconTheme.size ?? 40,
                  ),
                ),
              ),
              if (addFieldVisible)
                Positioned(
                  bottom: 15,
                  left: 75,
                  right: 75,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter category name here',
                    ),
                  ),
                ),
              if (addFieldVisible)
                Positioned(
                  bottom: 15,
                  left: 15,
                  child: FloatingActionButton(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    shape: CircleBorder(),
                    onPressed: () => _hideButtonFunction(),
                    heroTag: 'hide_add_field',
                    child: Icon(
                      Icons.arrow_right,
                      color: Theme.of(context).colorScheme.primary,
                      size: Theme.of(context).iconTheme.size ?? 40,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
