import 'package:flutter/foundation.dart' show immutable;
import 'package:home_organizer/features/auth/data/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait...',
  });
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required super.isLoading});
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut({
    required super.isLoading,
    super.loadingText,
    this.exception,
  });
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({required super.isLoading, this.exception});
}

class AuthStateNeedVerification extends AuthState {
  const AuthStateNeedVerification({required super.isLoading});
}

class AuthStateResetPassword extends AuthState {
  final bool didSendEmail;
  final Exception? exception;
  const AuthStateResetPassword({
    required this.didSendEmail,
    this.exception,
    required super.isLoading,
  });
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user, required super.isLoading});
}
