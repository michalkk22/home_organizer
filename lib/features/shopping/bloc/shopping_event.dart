import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class ShoppingEvent {
  const ShoppingEvent();
}

class ShoppingEventLoad extends ShoppingEvent {
  const ShoppingEventLoad();
}

class ShoppingEventAction extends ShoppingEvent {
  final ShoppingAction action;

  const ShoppingEventAction({required this.action});
}

enum ShoppingAction { add, update, delete }
