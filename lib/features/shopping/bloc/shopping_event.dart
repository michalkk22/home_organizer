import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/features/shopping/data/shopping_item.dart';

@immutable
abstract class ShoppingEvent {
  const ShoppingEvent();
}

class ShoppingEventLoad extends ShoppingEvent {
  const ShoppingEventLoad();
}

class ShoppingEventAction extends ShoppingEvent {
  final ShoppingAction action;
  final ShoppingItem item;

  const ShoppingEventAction({required this.action, required this.item});
}

enum ShoppingAction { add, update, delete }
