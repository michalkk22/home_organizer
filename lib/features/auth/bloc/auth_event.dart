import 'package:flutter/foundation.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventWantToRegister extends AuthEvent {
  const AuthEventWantToRegister();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;

  const AuthEventRegister({required this.email, required this.password});
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;

  const AuthEventLogIn({required this.email, required this.password});
}
