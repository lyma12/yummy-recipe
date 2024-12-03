import 'dart:convert';

import 'package:base_code_template_flutter/data/models/api/responses/nutrition/nutrients.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipes_random_response.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageManager {
  SecureStorageManager(this._storage);

  final FlutterSecureStorage _storage;

  static const _recipe = 'recipe';
  static const _recipesRandomResponse = "recipesRandomResponse";
  static const _similarRecipes = 'similarRecipes';
  static const _nutritionInRecipes = 'nutrition';

  Future<String?> _read({
    required String key,
  }) async {
    return _storage.read(key: key);
  }

  // Future<void> _delete({
  //   required String key,
  // }) async {
  //   await _storage.delete(key: key);
  // }

  Future<void> _write({
    required String key,
    required String? value,
  }) async {
    await _storage.write(key: key, value: value);
  }

  Future<List<Recipe>?> readRecipesRandomResponse(int offset) async {
    final result = await _read(key: _recipesRandomResponse);
    if (result == null) {
      return null;
    }
    try {
      final response = RecipesRandomResponse.fromJson(json.decode(result));
      if (response.offset == offset) {
        return response.results;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> writeRecipesRandomResponse(
      RecipesRandomResponse? recipeList) async {
    try {
      await _write(
        key: _recipe,
        value: json.encode(recipeList),
      );
    } catch (_) {}
  }

  Future<Recipe?> readRecipe(int id) async {
    final result = await _read(key: _recipe);
    if (result == null) {
      return null;
    }
    try {
      final recipe = Recipe.fromJson(json.decode(result));
      if (recipe.id == id) {
        return recipe;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> writeRecipe(Recipe? recipe) async {
    try {
      await _write(
        key: _recipe,
        value: json.encode(recipe),
      );
    } catch (_) {}
  }

  Future<List<Recipe>?> readSimilarRecipes(int id) async {
    final result = await _read(key: _similarRecipes);
    if (result == null) {
      return null;
    }
    try {
      final map = json.decode(result) as Map<String, dynamic>;
      final similarRecipes = map['similarRecipes'] as List<dynamic>;
      List<Recipe> response = [];
      for (var i in similarRecipes) {
        Recipe similarRecipe = Recipe.fromJson(i);
        response.add(similarRecipe);
      }
      final cacheId = map['id'] as int;
      if (id == cacheId) {
        return response;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> writeSimilarRecipes(int id, List<Recipe>? similarRecipes) async {
    try {
      final data = {'id': id, 'similarRecipes': similarRecipes ?? []};
      final value = json.encode(data);
      await _write(key: _similarRecipes, value: value);
    } catch (_) {}
  }

  Future<Nutrition?> readNutritionInRecipe(int id) async {
    final result = await _read(key: _nutritionInRecipes);
    if (result == null) {
      return null;
    }
    try {
      final map = json.decode(result) as Map<String, dynamic>;
      final nutrition = map['nutrition'] as Nutrition;
      final cacheId = map['id'] as int;
      if (cacheId == id) {
        return nutrition;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> writeNutrionInRecipe(int id, Nutrition nutrition) async {
    try {
      final data = {'id': id, 'nutrition': nutrition};
      final value = json.encode(data);
      await _write(key: _nutritionInRecipes, value: value);
    } catch (_) {}
  }
}
