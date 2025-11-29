import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/constants/firebase_storage_constants.dart';

@immutable
class ShoppingItem {
  final String? id;
  final String name;
  final double? quantity;
  final String? unit;
  final bool inCart;

  const ShoppingItem({
    this.id,
    required this.name,
    this.quantity,
    this.unit,
    this.inCart = false,
  });

  factory ShoppingItem.fromFirebase(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return ShoppingItem(
      id: snapshot.id,
      name: data?[ShoppingListCollectionNames.nameFieldName],
      quantity: data?[ShoppingListCollectionNames.quantityFieldName],
      unit: data?[ShoppingListCollectionNames.unitFieldName],
      inCart: data?[ShoppingListCollectionNames.inCartFieldName],
    );
  }

  ShoppingItem copyWith({
    final String? name,
    final double? quantity,
    final String? unit,
    final bool? inCart,
  }) => ShoppingItem(
    id: id,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    inCart: inCart ?? this.inCart,
  );
}
