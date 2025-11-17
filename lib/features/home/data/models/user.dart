import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/features/home/data/models/permissions.dart';

@immutable
class User {
  final String id;
  final String? name;
  final Permissions? permissions;
  const User({required this.id, required this.name, this.permissions});

  factory User.fromFirestore({
    required DocumentSnapshot<Map<String, dynamic>> snapshot,
    Permissions? permissions,
  }) {
    final data = snapshot.data();
    return User(id: snapshot.id, name: data?['name'], permissions: permissions);
  }
}
