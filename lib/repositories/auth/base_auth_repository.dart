import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuthRepository {
  Future<User?> loginViaEmail(String email, String password) async {}
}
