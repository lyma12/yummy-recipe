import 'package:base_code_template_flutter/data/models/user/user_firebase_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class SignInRepository {
  Future<UserCredential> signIn();
}

abstract class AuthRepository {
  Future<UserCredential> signIn(String email, String password);

  Future<UserCredential> signup(String email, String password);

  Future<void> signOut();

  User getUserCredential();

  UserFirebaseProfile getUserProfile();

  Future<void> editProfile(UserFirebaseProfile profile);
}

class FacebookRepositoryImpl implements SignInRepository {
  @override
  Future<UserCredential> signIn() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    throw Exception(result);
  }
}

class GoogleRepositoryImpl implements SignInRepository {
  @override
  Future<UserCredential> signIn() async {
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
  Future<UserCredential> signIn(String email, String password) async {
    return await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<UserCredential> signup(String email, String password) async {
    return await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() {
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

  @override
  Future<void> editProfile(UserFirebaseProfile profile) async {
    User user = getUserCredential();

    await Future.wait([
      user.updateDisplayName(profile.name).catchError((error) =>
          throw FirebaseAuthException(
              code: "failed to update name",
              message: "failed to update name firebase profile")),
      user.updatePhotoURL(profile.imageUrl).catchError((error) =>
          throw FirebaseAuthException(
              code: "failed to update image",
              message: "failed to update image firebase profile")),
    ]);
  }
}
