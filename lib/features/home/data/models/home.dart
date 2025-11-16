import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/constants/firebase_storage_constants.dart';
import 'package:home_organizer/features/home/data/models/permissions.dart';
import 'package:home_organizer/features/home/data/models/user.dart';

@immutable
class Home {
  final String name;
  final Map<User, Permissions?> members;
  const Home({required this.name, required this.members});

  factory Home.fromFirestore({
    required Map<User, Permissions?> members,
    required DocumentSnapshot<Map<String, dynamic>> homeSnapshot,
  }) {
    final data = homeSnapshot.data();
    return Home(
      name: data?[HomesCollectionNames.nameFieldName],
      members: members,
    );
  }
}
