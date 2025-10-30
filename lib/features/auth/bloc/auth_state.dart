import 'package:flutter/foundation.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut();
}
