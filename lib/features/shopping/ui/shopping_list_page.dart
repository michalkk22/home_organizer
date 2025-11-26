import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/shopping/bloc/shopping_bloc.dart';
import 'package:home_organizer/features/shopping/bloc/shopping_state.dart';
import 'package:home_organizer/features/shopping/ui/shopping_list_view.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingBloc, ShoppingState>(
      builder: (context, state) {
        if (state is ShoppingStateRunning) {
          return ShoppingListView();
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
