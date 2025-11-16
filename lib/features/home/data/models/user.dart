import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/features/home/data/models/permissions.dart';

@immutable
class User {
  final String? name;
  final Permissions? permissions;
  const User({required this.name, this.permissions});

  factory User.fromFirestore({
    required Map<String, dynamic> data,
    Permissions? permissions,
  }) {
    return User(name: data['name'], permissions: permissions);
  }
}
