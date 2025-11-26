import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/constants/firebase_storage_constants.dart';

@immutable
class ExpenditureCategory {
  final String? id;
  final String name;

  const ExpenditureCategory({this.id, required this.name});

  factory ExpenditureCategory.fromFirebase({
    required DocumentSnapshot<Map<String, dynamic>> snapshot,
  }) {
    final data = snapshot.data();
    return ExpenditureCategory(
      id: snapshot.id,
      name: data?[ExpenditureCategoriesCollectionNames.nameFieldName],
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! ExpenditureCategory) {
      return false;
    }
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
