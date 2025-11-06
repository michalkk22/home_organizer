import 'package:home_organizer/features/auth/data/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> sendEmailVerification();
  Future<void> resetPassword({required String email});
  Future<AuthUser> logIn({required String email, required String password});
  Future<AuthUser> googleLogIn();
  Future<void> logOut();
  Future<void> initialize();
}
