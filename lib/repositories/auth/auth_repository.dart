import 'package:firebase_auth/firebase_auth.dart';

import 'package:foods_app/repositories/auth/base_auth_repository.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseAuth auth;

  AuthRepository({
    required this.auth,
  });

  @override
  Future<User?> loginViaEmail(String email, String password) async {
    User? user;
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = credential.user;
    } catch (e) {
      rethrow;
    }
    return user;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
