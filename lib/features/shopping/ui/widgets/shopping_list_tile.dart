import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/shopping/bloc/shopping_bloc.dart';
import 'package:home_organizer/features/shopping/bloc/shopping_event.dart';
import 'package:home_organizer/features/shopping/data/shopping_item.dart';
import 'package:home_organizer/widgets/number_input_with_arrows.dart';

class ShoppingListTile extends StatefulWidget {
  const ShoppingListTile({super.key, required this.item});
  final ShoppingItem item;

  @override
  State<ShoppingListTile> createState() => _ShoppingListTileState();
}

class _ShoppingListTileState extends State<ShoppingListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        spacing: 4,
        children: [
          Text(widget.item.name),
          NumberInputWithArrows(
            initialValue: widget.item.quantity ?? 0,
            onChanged:
                (value) => context.read<ShoppingBloc>().add(
                  ShoppingEventAction(
                    action: ShoppingAction.update,
                    item: widget.item.copyWith(quantity: value),
                  ),
                ),
          ),
        ],
      ),
      leading: Checkbox(
        value: widget.item.inCart,
        onChanged:
            (value) => context.read<ShoppingBloc>().add(
              ShoppingEventAction(
                action: ShoppingAction.update,
                item: widget.item.copyWith(inCart: value),
              ),
            ),
      ),
      trailing: IconButton(
        onPressed:
            () => context.read<ShoppingBloc>().add(
              ShoppingEventAction(
                action: ShoppingAction.delete,
                item: widget.item,
              ),
            ),
        icon: Icon(Icons.delete),
      ),
    );
  }
}
