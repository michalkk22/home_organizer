import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/features/shopping/data/shopping_item.dart';

@immutable
abstract class ShoppingState {
  final bool isLoading;
  final List<ShoppingItem>? items;
  const ShoppingState({required this.isLoading, this.items});
}

class ShoppingStateLoading extends ShoppingState {
  const ShoppingStateLoading() : super(isLoading: true);
}

class ShoppingStateRunning extends ShoppingState {
  final Exception? exception;

  const ShoppingStateRunning({
    required super.isLoading,
    required super.items,
    this.exception,
  });
}
