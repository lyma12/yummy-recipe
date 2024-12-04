import 'package:base_code_template_flutter/data/providers/api_spoonacular_provider.dart';
import 'package:base_code_template_flutter/data/repositories/api/spoonacular/spoonacular_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/constants/firebae_recipe_field_name.dart';
import '../../utilities/utilities.dart';
import '../models/recipe/recipe.dart';
import '../repositories/firebase/recipe_firebase_store_repository.dart';

final recipeSpoonacularRepositoryProvider =
    Provider<RecipeSpoonacularRepository>(
  (ref) => RecipeSpoonacularRepositoryImpl(
    ref.watch(apiSpoonacularProvider),
  ),
);
final recipeFirebaseRepositoryProvider =
    Provider<RecipeFirebaseStoreRepository>((ref) =>
        RecipeFirebaseStoreRepositoryImpl(FirebaseFirestore.instance
            .collection(FirebaseRecipeFieldName.recipe)
            .withConverter<FirebaseRecipe>(fromFirestore: (snapshot, _) {
          return Utilities.converterRecipeFromFirebase(snapshot.data() ?? {});
        }, toFirestore: (recipe, _) {
          return Utilities.converterRecipeToFirebase(recipe);
        })));
