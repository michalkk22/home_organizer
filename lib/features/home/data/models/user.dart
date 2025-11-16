import 'package:flutter/foundation.dart' show immutable;

@immutable
class User {
  final String id;
  final String name;
  const User({required this.id, required this.name});

  factory User.fromFirebase(String id, Map<String, dynamic> data) {
    return User(id: id, name: data['name'] as String? ?? '');
  }
}
