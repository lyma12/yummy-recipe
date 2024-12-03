import 'package:firebase_auth/firebase_auth.dart';

abstract class SignupRepository {
  Future<UserCredential> signup(String email, String password);
}

class SignupRepositoryImpl implements SignupRepository {
  @override
  Future<UserCredential> signup(String email, String password) async {
    return await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }
}
