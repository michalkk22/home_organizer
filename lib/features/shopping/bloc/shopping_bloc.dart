import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_organizer/features/shopping/bloc/shopping_event.dart';
import 'package:home_organizer/features/shopping/bloc/shopping_state.dart';
import 'package:home_organizer/features/shopping/data/shopping_item.dart';
import 'package:home_organizer/features/shopping/data/shopping_repository.dart';

class ShoppingBloc extends Bloc<ShoppingEvent, ShoppingState> {
  StreamSubscription? _sub;

  ShoppingBloc(ShoppingRepository shoppingRepo)
    : super(ShoppingStateLoading()) {
    on<ShoppingEventLoad>((event, emit) {
      _sub?.cancel();
      _sub = shoppingRepo.getItems().listen(
        (items) => add(_ShopppingEventUpdate(items: items)),
      );
    });

    on<_ShopppingEventUpdate>(
      (event, emit) =>
          emit(ShoppingStateRunning(isLoading: false, items: event.items)),
    );

    on<ShoppingEventAction>((event, emit) {
      try {
        emit(ShoppingStateRunning(isLoading: true, items: state.items));
        switch (event.action) {
          case ShoppingAction.add:
            shoppingRepo.add(event.item);
            break;
          case ShoppingAction.update:
            shoppingRepo.update(event.item);
            break;
          case ShoppingAction.delete:
            shoppingRepo.delete(event.item);
            break;
        }
      } on Exception catch (e) {
        emit(
          ShoppingStateRunning(
            isLoading: false,
            items: state.items,
            exception: e,
          ),
        );
      }
    });
  }
}

class _ShopppingEventUpdate extends ShoppingEvent {
  final List<ShoppingItem> items;

  const _ShopppingEventUpdate({required this.items});
}
