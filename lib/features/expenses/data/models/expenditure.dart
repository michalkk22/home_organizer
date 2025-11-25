import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/constants/firebase_storage_constants.dart';
import 'package:home_organizer/features/expenses/data/models/expenditure_category.dart';

@immutable
class Expenditure {
  final String? id;
  final String? userId;
  final String? userName;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenditureCategory? category;

  const Expenditure({
    required this.id,
    required this.userId,
    required this.userName,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  factory Expenditure.fromFirebase({
    required DocumentSnapshot<Map<String, dynamic>> snapshot,
    String? userName,
    required ExpenditureCategory? category,
  }) {
    final data = snapshot.data();
    final time = data?[ExpensesCollectionNames.dateFieldName] as Timestamp;
    final date = time.toDate();
    return Expenditure(
      id: snapshot.id,
      userId: data?[ExpensesCollectionNames.userIdFieldName],
      userName: userName,
      title: data?[ExpensesCollectionNames.titleFieldName],
      amount: data?[ExpensesCollectionNames.amountFieldName],
      date: date,
      category: category,
    );
  }
}
