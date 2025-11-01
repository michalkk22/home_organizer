import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/features/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut({this.exception});
}

class AuthStateRegistering extends AuthState {
  const AuthStateRegistering();
}

class AuthStateNeedVerification extends AuthState {
  final Exception? exception;
  const AuthStateNeedVerification({this.exception});
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user});
}
