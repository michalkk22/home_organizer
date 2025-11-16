import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/constants/firebase_storage_constants.dart';

@immutable
class Permissions {
  final bool isOwner;

  const Permissions({this.isOwner = false});

  factory Permissions.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Permissions(
      isOwner: data?[HomesCollectionNames.isOwnerFieldName] ?? false,
    );
  }
}
