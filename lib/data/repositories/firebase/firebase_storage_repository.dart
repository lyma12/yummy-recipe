import 'dart:io';

import 'package:base_code_template_flutter/utilities/utilities.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

abstract class FirebaseStorageRepository {
  Future<String> saveRecipe(String id, File? image);

  Future<String> saveAvatar(String userId, File image);
}

class FirebaseStorageRepositoryImpl implements FirebaseStorageRepository {
  const FirebaseStorageRepositoryImpl(this._storageRef);

  final Reference _storageRef;

  @override
  Future<String> saveRecipe(String id, File? image) async {
    if (image != null) {
      return await saveRecipeImage(image, id);
    } else {
      throw Exception('save data is null');
    }
  }

  Future<String> saveRecipeImage(File image, String id) async {
    final recipeRef = _storageRef.child(Utilities.firebaseStorageRefImage(id));
    final data = await image.readAsBytes();
    try {
      await recipeRef.putData(data);
      if (kDebugMode) {
        print("Image uploaded successfully.");
      }
      return await recipeRef.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print("Failed to upload image: $e");
      }
      throw Exception("Failed to upload image: $e");
    }
  }

  @override
  Future<String> saveAvatar(String userId, File image) async {
    if (kDebugMode) {
      print(userId);
    }
    final avatarRef =
        _storageRef.child(Utilities.firebaseStorageRefAvatar(userId));
    final data = await image.readAsBytes();
    try {
      await avatarRef.putData(data);
      if (kDebugMode) {
        print("Image uploaded successfully.");
      }
      return await avatarRef.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print("Failed to upload image: $e");
      }
      throw Exception("Failed to upload image: $e");
    }
  }
}
