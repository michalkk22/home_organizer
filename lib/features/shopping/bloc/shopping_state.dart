import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class ShoppingState {
  const ShoppingState();
}

class ShoppingStateLoading extends ShoppingState {
  const ShoppingStateLoading();
}

class ShoppingStateRunning extends ShoppingState {
  const ShoppingStateRunning();
}
