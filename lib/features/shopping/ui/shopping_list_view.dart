import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/shopping/bloc/shopping_bloc.dart';
import 'package:home_organizer/features/shopping/bloc/shopping_event.dart';
import 'package:home_organizer/features/shopping/data/shopping_item.dart';
import 'package:home_organizer/features/shopping/ui/widgets/shopping_list_tile.dart';
import 'package:home_organizer/widgets/floating_dropdown_text_field.dart';

class ShoppingListView extends StatelessWidget {
  const ShoppingListView({super.key, required this.items});
  final List<ShoppingItem> items;

  @override
  Widget build(BuildContext context) {
    final List<ShoppingItem> notInCart =
        items.where((item) => !item.inCart).toList();
    final List<ShoppingItem> inCart =
        items.where((item) => item.inCart).toList();

    return FloatingDropdownTextField(
      hintText: 'Enter item name here',
      onAdd:
          (text) => context.read<ShoppingBloc>().add(
            ShoppingEventAction(
              action: ShoppingAction.add,
              item: ShoppingItem(name: text),
            ),
          ),
      body: Column(
        spacing: 3,
        children: [
          ListView.separated(
            shrinkWrap: true,
            itemCount: notInCart.length,
            itemBuilder: (context, index) {
              final item = notInCart[index];
              return ShoppingListTile(key: ValueKey(item), item: item);
            },
            separatorBuilder:
                (BuildContext context, int index) => const Divider(height: 2),
          ),
          if (inCart.isNotEmpty) Text('In cart:'),
          ListView.separated(
            shrinkWrap: true,
            itemCount: inCart.length,
            itemBuilder: (context, index) {
              final item = inCart[index];
              return ShoppingListTile(key: ValueKey(item), item: item);
            },
            separatorBuilder:
                (BuildContext context, int index) => const Divider(height: 2),
          ),
        ],
      ),
    );
  }
}
