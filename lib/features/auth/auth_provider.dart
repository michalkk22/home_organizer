abstract class AuthProvider {
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  });
  void logIn({required String email, required String password});
  void logOut();
  Future<void> initialize();
}
