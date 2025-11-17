import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/constants/firebase_storage_constants.dart';
import 'package:home_organizer/features/home/data/models/permissions.dart';
import 'package:home_organizer/features/home/data/models/user.dart';

@immutable
class Home {
  final String id;
  final String name;
  final Map<User, Permissions?> members;
  const Home({required this.id, required this.name, required this.members});

  factory Home.fromFirestore({
    required Map<User, Permissions?> members,
    required DocumentSnapshot<Map<String, dynamic>> snapshot,
  }) {
    final data = snapshot.data();
    return Home(
      id: snapshot.id,
      name: data?[HomesCollectionNames.nameFieldName],
      members: members,
    );
  }
}
