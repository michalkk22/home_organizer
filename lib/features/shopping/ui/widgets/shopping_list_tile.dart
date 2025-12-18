import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/shopping/bloc/shopping_bloc.dart';
import 'package:home_organizer/features/shopping/bloc/shopping_event.dart';
import 'package:home_organizer/features/shopping/data/shopping_item.dart';
import 'package:home_organizer/widgets/number_input_with_arrows.dart';
import 'package:home_organizer/widgets/themed_text_field.dart';

class ShoppingListTile extends StatefulWidget {
  const ShoppingListTile({super.key, required this.item});
  final ShoppingItem item;

  @override
  State<ShoppingListTile> createState() => _ShoppingListTileState();
}

class _ShoppingListTileState extends State<ShoppingListTile> {
  late final TextEditingController _name;
  late final TextEditingController _unit;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.item.name);
    _unit = TextEditingController(text: widget.item.unit);
  }

  @override
  void dispose() {
    super.dispose();
    _unit.dispose();
    _name.dispose();
  }

  final double textFieldHeight = 40;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 4,
        children: [
          Checkbox(
            value: widget.item.inCart,
            onChanged: (value) => _update(widget.item.copyWith(inCart: value)),
          ),
          Expanded(
            child: ThemedTextField(
              height: textFieldHeight,
              controller: _name,
              onChanged: () => _update(widget.item.copyWith(name: _name.text)),
            ),
          ),
          NumberInputWithArrows(
            initialValue: widget.item.quantity ?? 0,
            onChanged:
                (value) => _update(widget.item.copyWith(quantity: value)),
          ),
          ThemedTextField(
            width: 50,
            height: textFieldHeight,
            controller: _unit,
            onChanged: () => _update(widget.item.copyWith(unit: _unit.text)),
          ),
          IconButton(
            onPressed:
                () => context.read<ShoppingBloc>().add(
                  ShoppingEventAction(
                    action: ShoppingAction.delete,
                    item: widget.item,
                  ),
                ),
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  _update(ShoppingItem item) {
    context.read<ShoppingBloc>().add(
      ShoppingEventAction(action: ShoppingAction.update, item: item),
    );
  }
}
