import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String id;
  final bool isEmailVerified;

  const AuthUser({required this.id, required this.isEmailVerified});

  factory AuthUser.fromFirebase(User user) =>
      AuthUser(id: user.uid, isEmailVerified: user.emailVerified);
}
