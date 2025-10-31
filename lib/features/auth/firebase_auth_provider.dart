import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_core/firebase_core.dart';
import 'package:home_organizer/features/auth/auth_provider.dart';
import 'package:home_organizer/firebase_options.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('CREATE USER: $user');
    } catch (e) {
      rethrow;
    }
  }

  @override
  void logIn({required String email, required String password}) {
    // TODO: implement logIn
  }

  @override
  void logOut() {
    // TODO: implement logOut
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
