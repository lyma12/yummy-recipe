import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/data/repositories/firebase/firebase_storage_repository.dart';
import 'package:base_code_template_flutter/data/repositories/firebase/firebase_store_repository.dart';
import 'package:base_code_template_flutter/utilities/constants/firebae_recipe_field_name.dart';
import 'package:base_code_template_flutter/utilities/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseStorageRepositoryProvider = Provider<FirebaseStorageRepository>(
    (ref) => FirebaseStorageRepositoryImpl(FirebaseStorage.instance.ref()));

final firebaseStoreRepositoryProvider = Provider<FirebaseStoreRespository>(
    (ref) => FirebaseStoreRepositoryImpl(FirebaseFirestore.instance
            .collection(FirebaseRecipeFieldName.recipe)
            .withConverter<FirebaseRecipe>(fromFirestore: (snapshot, _) {
          return Utilities.converterRecipeFromFirebase(snapshot.data() ?? {});
        }, toFirestore: (recipe, _) {
          return Utilities.converterRecipeToFirebase(recipe);
        })));
