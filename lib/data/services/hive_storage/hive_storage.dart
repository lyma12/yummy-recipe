import 'dart:async';

import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipes_random_response.dart';
import 'package:base_code_template_flutter/data/models/queries/queries.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:hive/hive.dart';

class HiveStorage {
  HiveStorage();

  static const _recipe = 'recipe';
  static const _ingredient = 'ingredient';
  static const _recipesRandomResponse = 'recipesRandomResponse';
  static const _similarRecipes = 'similarRecipes';
  static const _recipeDataSave = 'recipe_save';
  static const _queries = 'queries';

  static const maxTimeStamp = 5;
  static const maxNumberInStorage = 10;

  Future<Recipe?> readRecipe(int id) async {
    var box = await Hive.openBox<Recipe>(_recipe);
    Recipe? response = box.get(id);
    if (response == null) {
      return null;
    }
    return response;
  }

  Future<void> writeRecipe(Recipe recipe) async {
    var box = await Hive.openBox<Recipe>(_recipe);
    DateTime now = DateTime.now();
    if (box.length >= maxNumberInStorage) {
      final datas = box.values.toList();
      for (var data in datas) {
        if (now.difference(data.timeStamp ?? now).inDays > maxTimeStamp) {
          await box.delete(recipe.id);
          break;
        }
      }
    }
    recipe = recipe.copyWith(
      timeStamp: now,
    );
    box.put(recipe.id, recipe);
  }

  Future<List<Recipe>?> readSaveRecipe() async {
    var box = await Hive.openBox<Recipe>(_recipeDataSave);
    return box.values.toList();
  }

  Future<void> writeSaveRecipe(Recipe recipe) async {
    var box = await Hive.openBox<Recipe>(_recipeDataSave);
    box.put(recipe.id, recipe);
  }

  Future<void> deleteSaveRecipe(Recipe recipe) async {
    var box = await Hive.openBox<Recipe>(_recipeDataSave);
    await box.delete(recipe.id);
  }

  Future<List<Recipe>?> readRecipesRandomResponse(int offset) async {
    var box = await Hive.openBox<RecipesRandomResponse>(_recipesRandomResponse);
    RecipesRandomResponse? response = box.get(offset);
    if (response == null) {
      return null;
    }
    return response.results;
  }

  Future<void> writeRecipesRandomResponse(RecipesRandomResponse recipes) async {
    var box = await Hive.openBox<RecipesRandomResponse>(_recipesRandomResponse);
    DateTime now = DateTime.now();
    if (box.length >= maxNumberInStorage) {
      bool isHasOldData = false;
      final datas = box.values.toList();
      for (var data in datas) {
        if (now.difference(data.timeStamp ?? now).inDays > maxTimeStamp) {
          await box.delete(recipes.offset);
          isHasOldData = true;
          break;
        }
      }
      if (!isHasOldData) {
        await box.delete(box.keys.first);
      }
    }
    recipes = recipes.copyWith(
      timeStamp: now,
    );
    box.put(recipes.offset, recipes);
  }

  Future<List<Recipe>?> readSimilarRecipe(int id) async {
    var box = await Hive.openBox<List<Recipe>>(_similarRecipes);
    var similarRecipe = box.get(id);
    if (similarRecipe == null) {
      return null;
    }
    return similarRecipe;
  }

  Future<void> writeSimilarRecipe(int id, List<Recipe> similarRecipe) async {
    var box = await Hive.openBox<List<Recipe>>(_similarRecipes);
    if (box.length >= maxNumberInStorage) {
      await box.delete(box.keys.first);
    }
    box.put(id, similarRecipe);
  }

  Future<List<Ingredient>?> readIngredient(String search) async {
    var box = await Hive.openBox<List<Ingredient>>(_ingredient);
    var ingredient = box.get(search);
    if (ingredient == null) {
      return null;
    }
    return ingredient;
  }

  Future<void> writeIngredient(
      String search, List<Ingredient> listIngredient) async {
    var box = await Hive.openBox<List<Ingredient>>(_ingredient);
    if (box.length >= maxNumberInStorage) {
      await box.delete(box.keys.first);
    }
    box.put(search, listIngredient);
  }

  Future<List<Recipe>?> readFirebaseRecipes(int offset) async {
    var box = await Hive.openBox<RecipesRandomResponse>(_recipesRandomResponse);
    RecipesRandomResponse? response = box.get(offset);
    if (response == null) {
      return null;
    }
    return response.results;
  }

  Future<void> saveQueries(Queries queries) async {
    var box = await Hive.openBox<Queries>(_queries);
    box.put(_queries, queries);
  }

  Future<Queries?> readQueries() async {
    var box = await Hive.openBox<Queries>(_queries);
    return box.get(_queries);
  }

  Future<void> clearDataAccount() async {
    await Future.wait([
      _clearBox<Recipe>(_recipeDataSave),
      _clearBox<Queries>(_queries),
      _clearBox<RecipesRandomResponse>(_recipesRandomResponse),
    ]);
  }

  Future _clearBox<T>(String nameBox) async {
    var box = await Hive.openBox<T>(nameBox);
    box.clear();
  }
}
