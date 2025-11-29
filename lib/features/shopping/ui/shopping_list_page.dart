import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/shopping/bloc/shopping_bloc.dart';
import 'package:home_organizer/features/shopping/bloc/shopping_state.dart';
import 'package:home_organizer/features/shopping/domain/shopping_repository_exception.dart';
import 'package:home_organizer/features/shopping/ui/shopping_list_view.dart';
import 'package:home_organizer/utils/dialogs/error_dialog.dart';
import 'package:home_organizer/utils/loading/loading_screen.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppingBloc, ShoppingState>(
      builder: (context, state) {
        if (state is ShoppingStateRunning) {
          return ShoppingListView(items: state.items ?? []);
        } else {
          return Container();
        }
      },
      listener: (BuildContext context, ShoppingState state) {
        if (state is ShoppingStateLoading) {
          LoadingScreen().show(context: context);
        } else {
          LoadingScreen().hide();
        }

        if (state is ShoppingStateRunning && state.exception != null) {
          if (state.exception is CouldNotCreateShoppingRepositoryException) {
            showErrorDialog(context, "We couldn't add the item to the list.");
          } else if (state.exception
              is CouldNotDeleteShoppingRepositoryException) {
            showErrorDialog(
              context,
              "We couldn't delete the item from the list.",
            );
          } else if (state.exception
              is CouldNotUpdateShoppingRepositoryException) {
            showErrorDialog(context, "We couldn't update the item.");
          } else {
            showErrorDialog(context, 'Unknown error');
          }
        }
      },
    );
  }
}
