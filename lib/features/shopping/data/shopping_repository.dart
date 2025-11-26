import 'package:home_organizer/features/shopping/data/shopping_item.dart';

abstract class ShoppingRepository {
  Stream<List<ShoppingItem>> getItems();
  Future<void> add(ShoppingItem item);
  Future<void> update(ShoppingItem item);
  Future<void> delete(ShoppingItem item);
}
