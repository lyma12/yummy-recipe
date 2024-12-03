import 'package:base_code_template_flutter/data/models/user/user_firebase_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class SigninRepository {
  Future<UserCredential> signin();
}

abstract class AuthRepository {
  Future<UserCredential> signin(String email, String password);

  Future<UserCredential> signup(String email, String password);

  Future<void> signout();

  User getUserCredential();

  UserFirebaseProfile getUserProfile();
}

class FacebookRepositoryImpl implements SigninRepository {
  @override
  Future<UserCredential> signin() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    throw Exception(result);
  }
}

class GoogleRepositoryImpl implements SigninRepository {
  @override
  Future<UserCredential> signin() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<UserCredential> signin(String email, String password) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<UserCredential> signup(String email, String password) {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signout() {
    return FirebaseAuth.instance.signOut();
  }

  @override
  User getUserCredential() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user;
    }
    throw FirebaseAuthException(code: "user-not-found");
  }

  @override
  UserFirebaseProfile getUserProfile() {
    User user = getUserCredential();
    UserFirebaseProfile userProfile = UserFirebaseProfile(
        id: user.uid,
        name: user.displayName ?? "user_${user.uid}",
        imageUrl: user.photoURL);
    return userProfile;
  }
}
