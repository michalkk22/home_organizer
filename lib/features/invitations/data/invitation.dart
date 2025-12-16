import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/constants/deeplink_constants.dart';
import 'package:home_organizer/constants/firebase_storage_constants.dart';

@immutable
class Invitation {
  final String id;
  final String homeId;
  final String homeName;
  final String senderId;
  final String senderName;
  final DateTime expiresAt;
  final List<String> usedBy;

  const Invitation({
    required this.id,
    required this.homeId,
    required this.homeName,
    required this.senderId,
    required this.senderName,
    required this.expiresAt,
    required this.usedBy,
  });

  String get link => invitationDeepLink + id;

  factory Invitation.fromFirebase({
    required DocumentSnapshot<Map<String, dynamic>> snapshot,
    required String homeName,
    required String senderName,
  }) {
    final data = snapshot.data();
    final timestamp =
        data?[InvitationsCollectionNames.expiresAtFieldName] as Timestamp;
    return Invitation(
      id: snapshot.id,
      homeId: data?[InvitationsCollectionNames.homeIdFieldName],
      homeName: homeName,
      senderId: data?[InvitationsCollectionNames.createdByFieldName],
      senderName: senderName,
      expiresAt: timestamp.toDate(),
      usedBy: List<String>.from(
        data?[InvitationsCollectionNames.usedByFieldName] ?? [],
      ),
    );
  }
}
