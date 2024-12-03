import 'package:base_code_template_flutter/data/models/user/spoonacular_account.dart';
import 'package:base_code_template_flutter/data/models/user/user_firebase_profile.dart';
import 'package:base_code_template_flutter/utilities/constants/firebase_user_profile_field_name.dart';
import 'package:base_code_template_flutter/utilities/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

abstract class UserProfileRepository {
  Future<void> editProfile(UserFirebaseProfile newProfile);

  Future<UserFirebaseProfile?> loadProfile(String id);

  Stream<UserFirebaseProfile?> listenProfile(String id);

  Future<SpoonacularAccount?> getSpoonacularAccount(String id);

  Future addSpoonacularAccount(
    SpoonacularAccount user,
    String id,
  );

  Future saveShoppingList(
    Map<String, Map<String, bool>> shoppingListState,
    String id,
  );

  Future<Map<String, Map<String, bool>>?> loadShoppingListState(
    String id,
  );
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

  @override
  Future addSpoonacularAccount(
    SpoonacularAccount user,
    String id,
  ) async {
    DocumentReference docRef = documentRef.doc(id);
    Map<String, dynamic> data = {};
    data[FirebaseUserProfileFieldName.spoonacular] = user.toJson();
    await docRef.update(data).then(
          (value) => debugPrint("Add spoonacular account success!"),
          onError: (e) => throw FirebaseException(
              plugin: 'fire store', message: 'Failed add spoonacular account!'),
        );
  }

  @override
  Future<SpoonacularAccount?> getSpoonacularAccount(String id) async {
    final profileRef = documentRef.doc(id);
    SpoonacularAccount? response;
    await profileRef.get().then(
      (data) {
        final user = data.data() as UserFirebaseProfile;
        response = user.spoonacularAccount;
      },
    ).catchError(
      (error) {
        debugPrint(error);
        throw FirebaseException(
            plugin: "fire store", message: "Failed get spoonacular account!");
      },
    );
    return response;
  }

  @override
  Future saveShoppingList(
      Map<String, Map<String, bool>> shoppingListState, String id) async {
    final profileRef = documentRef.doc(id);
    final data = Utilities.converterShoppingListForFirebase(shoppingListState);
    await profileRef
        .update(data)
        .then((_) => debugPrint("Update shopping list state success!"),
            onError: (error) {
      debugPrint(error.toString());
      throw FirebaseException(
          plugin: "fire store", message: "Failed update shopping list state!");
    });
  }

  @override
  Future<Map<String, Map<String, bool>>?> loadShoppingListState(
      String id) async {
    final profileRef = documentRef.doc(id);
    Map<String, Map<String, bool>>? data;
    await profileRef.get().then((snapshot) {
      final user = snapshot.data() as UserFirebaseProfile;
      if (user.shoppingList.isNotEmpty) data = user.shoppingList;
    }, onError: (error) {
      debugPrint(error);
      throw FirebaseException(
          plugin: "fire store", message: "Failed update shopping list state!");
    });
    return data;
  }
}
