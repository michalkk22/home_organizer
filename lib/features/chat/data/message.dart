import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/constants/firebase_storage_constants.dart';

@immutable
class Message {
  final String sender;
  final String text;
  final DateTime timestamp;

  const Message({
    required this.sender,
    required this.text,
    required this.timestamp,
  });

  factory Message.fromFirebase(
    String senderName,
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    final timestamp =
        data?[ChatCollectionNames.timestampFieldName] as Timestamp;
    return Message(
      sender: senderName,
      text: data?[ChatCollectionNames.textFieldName],
      timestamp: timestamp.toDate(),
    );
  }
}
