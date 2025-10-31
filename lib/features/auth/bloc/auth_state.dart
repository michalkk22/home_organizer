import 'package:flutter/foundation.dart';
import 'package:home_organizer/models/user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut();
}

class AuthStateRegistering extends AuthState {
  const AuthStateRegistering();
}

class AuthStateNeedVerification extends AuthState {
  const AuthStateNeedVerification();
}

class AuthStateLoggedIn extends AuthState {
  final User user;
  const AuthStateLoggedIn({required this.user});
}
