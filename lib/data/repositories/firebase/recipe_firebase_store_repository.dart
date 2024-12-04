import 'dart:async';

import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/utilities/constants/firebae_recipe_field_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

abstract class RecipeFirebaseStoreRepository {
  Future<void> saveRecipePost(Recipe? recipe);

  Stream<Recipe>? listenRecipe(String id);

  Future<void> updateRecipes(Map<String, dynamic> updates, String id);

  Stream<List<Recipe>> listenRecipesStream(int length);

  String getGenerationId();
}

class RecipeFirebaseStoreRepositoryImpl
    implements RecipeFirebaseStoreRepository {
  const RecipeFirebaseStoreRepositoryImpl(this.documentRef);

  final CollectionReference documentRef;
  final int limitRecipe = 1;

  @override
  Stream<Recipe>? listenRecipe(String id) {
    final dataRef = documentRef.doc(id);
    return dataRef.snapshots().map((snapshot) {
      return snapshot.data() as FirebaseRecipe;
    });
  }

  @override
  Future<void> saveRecipePost(Recipe? recipe) async {
    if (recipe == null && recipe is! FirebaseRecipe) return;
    await documentRef.doc(recipe?.id as String).set(recipe).then((onValue) {
      debugPrint('recipe add');
    }).catchError((error) {
      debugPrint("Failed to add recipe: $error");
      throw FirebaseException(plugin: "Failed to add recipe: $error");
    });
  }

  @override
  String getGenerationId() {
    return documentRef.doc().id;
  }

  @override
  Future<void> updateRecipes(Map<String, dynamic> updates, String id) async {
    final recipeRef = documentRef.doc(id);
    await recipeRef
        .update(updates)
        .then((value) => ("DocumentSnapshot successfully updated!"),
            onError: (e) => throw FirebaseException(
                  plugin: "Error updating document $e",
                ));
  }

  @override
  Stream<List<Recipe>> listenRecipesStream(int length) {
    Query query = documentRef
        .orderBy(FirebaseRecipeFieldName.createAt, descending: true)
        .limit(length);
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data() as FirebaseRecipe).toList();
    });
  }
}
