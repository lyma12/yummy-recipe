import 'package:base_code_template_flutter/data/models/user/user_firebase_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

abstract class UserProfileRepository {
  Future<void> editProfile(UserFirebaseProfile newProfile);

  Future<UserFirebaseProfile?> loadProfile(String id);

  Stream<UserFirebaseProfile?> listenProfile(String id);
}

class UserFirebaseStoreRepositoryImpl implements UserProfileRepository {
  const UserFirebaseStoreRepositoryImpl(this.documentRef);

  final CollectionReference documentRef;

  @override
  Future<void> editProfile(UserFirebaseProfile newProfile) async {
    await documentRef.doc(newProfile.id).set(newProfile).then((value) {
      debugPrint('user profile edit');
    }).catchError((error) {
      debugPrint('Failed to edit user profile: $error');
      throw FirebaseException(
          plugin: error, message: "Failed to edit user profile");
    });
  }

  @override
  Future<UserFirebaseProfile?> loadProfile(String id) async {
    final profileRef = documentRef.doc(id);
    UserFirebaseProfile? response;
    await profileRef.get().then((data) {
      if (data.data() != null) {
        response = data.data() as UserFirebaseProfile;
      }
    }).catchError((error) {
      debugPrint("Failed to load profile: $error");
      throw FirebaseException(
          plugin: "Failed to load profile: $error",
          message: "Failed to load profile: $error");
    });
    return response;
  }

  @override
  Stream<UserFirebaseProfile?> listenProfile(String id) {
    final profileRef = documentRef.doc(id);
    return profileRef.snapshots().map((event) {
      if (event.exists) {
        return event.data() as UserFirebaseProfile;
      } else {
        return null;
      }
    });
  }
}
