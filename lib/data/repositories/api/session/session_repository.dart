import 'package:base_code_template_flutter/data/models/api/responses/nutrition/nutrients.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipes_random_response.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class SessionRepository {
  List<Recipe>? recipesRandomResponse(int offset);

  void saveRecipesRandomResponse(RecipesRandomResponse? recipeList);

  Recipe? getRecipe(int id);

  void saveRecipe(Recipe recipe);

  List<Recipe>? getSimilarRecipes(int id);

  void saveSimilarRecipes(List<Recipe>? similarRecipes);

  Nutrition? getNutritionInRecipe(int id);

  void saveNutritionInRecipe(Nutrition nutrition);

  QueryDocumentSnapshot<Object?>? getLastSnapshot();

  void saveLastSnapshot(QueryDocumentSnapshot<Object?>? snapshot);
}

class SessionRepositoryImpl implements SessionRepository {
  RecipesRandomResponse? _recipeList;

  Recipe? _recipe;

  List<Recipe>? _similarRecipes;
  Nutrition? _nutrition;

  QueryDocumentSnapshot<Object?>? _lastSnapshot;

  @override
  List<Recipe>? recipesRandomResponse(int offset) {
    if (_recipeList != null && _recipeList?.offset == offset) {
      return _recipeList?.results;
    }
    return null;
  }

  @override
  void saveRecipesRandomResponse(RecipesRandomResponse? recipeList) {
    _recipeList = recipeList;
  }

  @override
  Recipe? getRecipe(int id) {
    if (_recipe?.id == id) {
      return _recipe;
    }
    return null;
  }

  @override
  void saveRecipe(Recipe recipe) {
    _recipe = recipe;
  }

  @override
  List<Recipe>? getSimilarRecipes(int id) {
    if (id == _recipe?.id) {
      return _similarRecipes;
    }
    return null;
  }

  @override
  void saveSimilarRecipes(List<Recipe>? similarRecipes) {
    _similarRecipes = similarRecipes;
  }

  @override
  Nutrition? getNutritionInRecipe(int id) {
    if (id == _recipe?.id) {
      return _nutrition;
    }
    return null;
  }

  @override
  void saveNutritionInRecipe(Nutrition nutrition) {
    _nutrition = nutrition;
  }

  @override
  QueryDocumentSnapshot<Object?>? getLastSnapshot() => _lastSnapshot;

  @override
  void saveLastSnapshot(QueryDocumentSnapshot<Object?>? snapshot) {
    _lastSnapshot = snapshot;
  }
}
