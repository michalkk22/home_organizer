import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/shopping/bloc/shopping_event.dart';
import 'package:home_organizer/features/shopping/bloc/shopping_state.dart';
import 'package:home_organizer/features/shopping/data/shopping_item.dart';
import 'package:home_organizer/features/shopping/data/shopping_repository.dart';

class ShoppingBloc extends Bloc<ShoppingEvent, ShoppingState> {
  late List<ShoppingItem> items;

  ShoppingBloc(ShoppingRepository shoppingRepo)
    : super(ShoppingStateLoading()) {}
}
