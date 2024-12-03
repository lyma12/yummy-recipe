import 'dart:convert';

import 'package:base_code_template_flutter/data/models/api/responses/nutrition/nutrients.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipes_random_response.dart';
import 'package:base_code_template_flutter/data/models/meal_plan/meal_plan.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/data/models/user/spoonacular_account.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/shopping_list/shopping_list.dart';

class SecureStorageManager {
  SecureStorageManager(this._storage);

  final FlutterSecureStorage _storage;

  static const _recipe = 'recipe';
  static const _recipesRandomResponse = "recipesRandomResponse";
  static const _similarRecipes = 'similarRecipes';
  static const _nutritionInRecipes = 'nutrition';
  static const _shoppingListItem = 'shopping_item';
  static const _shoppingState = 'shopping_state';
  static const _mealPlan = 'mealPlan';
  static const _spoonacularAccount = 'spoonacularAccount';
  static const _haveChangeShoppingItem = 'changeShoppingList';
  static const _mealplanDay = 'mealplan_day';

  Future<String?> _read({
    required String key,
  }) async {
    return _storage.read(key: key);
  }

  Future<void> _delete({
    required String key,
  }) async {
    await _storage.delete(key: key);
  }

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

  Future writeShoppingList(Map<String, List<ItemAisles>> shoppingList) async {
    try {
      final valueListItem = json.encode(shoppingList);
      await _write(key: _shoppingListItem, value: valueListItem);
      await _write(key: _haveChangeShoppingItem, value: '1');
    } catch (_) {}
  }

  Future writeShoppingState(Map<String, Map<String, bool>> listState) async {
    try {
      final valueListState = json.encode(listState);
      await _write(key: _shoppingState, value: valueListState);
      await _write(key: _haveChangeShoppingItem, value: '1');
    } catch (_) {}
  }

  Future<Map<String, Map<String, bool>>?> readShoppingState() async {
    final result = await _read(key: _shoppingState);
    if (result == null) {
      return null;
    }
    try {
      final map = json.decode(result) as Map<String, dynamic>;
      Map<String, Map<String, bool>> resultResponse = {};
      map.forEach((key, value) {
        Map<String, bool> mapItemState = {};
        if (value is Map) {
          value.forEach((iKey, iValue) {
            mapItemState[iKey] = iValue as bool;
          });
          resultResponse[key] = mapItemState;
        }
      });
      return resultResponse;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, List<ItemAisles>>?> readShoppingList() async {
    final result = await _read(key: _shoppingListItem);
    if (result == null) {
      return null;
    }
    try {
      final map = json.decode(result) as Map<String, dynamic>;
      Map<String, List<ItemAisles>> resultResponse = {};
      map.forEach((key, value) {
        if (value is List) {
          List<ItemAisles> listItem = [];
          for (var i in value) {
            listItem.add(ItemAisles.fromJson(i));
          }
          resultResponse[key] = listItem;
        }
      });
      return resultResponse;
    } catch (_) {
      return null;
    }
  }

  Future writeSpoonacularAccount(SpoonacularAccount account) async {
    try {
      final value = json.encode(account);
      await _write(key: _spoonacularAccount, value: value);
    } catch (_) {}
  }

  Future<SpoonacularAccount?> readSpoonacularAccount(String uid) async {
    final result = await _read(key: _spoonacularAccount);
    if (result == null) {
      return null;
    }
    try {
      final map = json.decode(result) as Map<String, dynamic>;
      return SpoonacularAccount.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<bool> readFlagChangeShoppingList() async {
    final result = await _read(key: _haveChangeShoppingItem);
    if (result == null) {
      return false;
    }
    try {
      final value = json.decode(result) as int;
      return value == 1;
    } catch (_) {
      return false;
    }
  }

  Future changeFlagShoppingList() async {
    try {
      final value = json.encode('0');
      await _write(key: _haveChangeShoppingItem, value: value);
    } catch (_) {}
  }

  Future writeMealPlanDay(MealPlanDay mealplan) async {
    try {
      final value = json.encode(mealplan);
      await _write(key: _mealplanDay, value: value);
    } catch (_) {}
  }

  Future<MealPlanDay?> readMealPlanDay(DateTime date) async {
    final result = await _read(key: _mealplanDay);
    try {
      if (result != null) {
        MealPlanDay mealPlan = MealPlanDay.fromJson(json.decode(result));
        if (mealPlan.date != null) {
          final intDateTime = date.microsecondsSinceEpoch ~/ 1000000;
          if (intDateTime == mealPlan.date) {
            return mealPlan;
          }
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future logOutAccount() async {
    await _delete(key: _haveChangeShoppingItem);
    await _delete(key: _spoonacularAccount);
    await _delete(key: _shoppingState);
    await _delete(key: _shoppingListItem);
    await _delete(key: _mealPlan);
  }
}
