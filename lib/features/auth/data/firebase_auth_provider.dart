import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, GoogleAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart'
    show GoogleSignIn, GoogleSignInException;
import 'package:home_organizer/features/auth/domain/auth_exception.dart';
import 'package:home_organizer/features/auth/data/auth_provider.dart';
import 'package:home_organizer/features/auth/data/auth_user.dart';
import 'package:home_organizer/firebase_options.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      throw _findAuthException(e.code);
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      throw _findAuthException(e.code);
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await GoogleSignIn.instance.initialize();
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    }
    return null;
  }

  @override
  Future<AuthUser> googleLogIn() async {
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw GenericAuthException();
      }
    } on GoogleSignInException catch (_) {
      throw GoogleSignInAuthException();
    } on FirebaseAuthException catch (e) {
      throw _findAuthException(e.code);
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _findAuthException(e.code);
    }
  }

  Exception _findAuthException(String code) {
    switch (code) {
      case 'invalid-email':
        throw InvalidEmailAuthException();
      case 'weak-password':
        throw WeakPasswordAuthException();
      case 'network-request-failed':
        throw NewtowrkFailAuthException();
      case 'user-not-found':
        throw UserNotFoundAuthException();
      case 'wrong-password':
        throw WrongPasswordAuthException();
      case 'account-exists-with-different-credential':
        throw DifferentCredentialAuthException();
      case 'invalid-credential':
        throw InvalidCredentialAuthException();
      default:
        throw GenericAuthException();
    }
  }
}
