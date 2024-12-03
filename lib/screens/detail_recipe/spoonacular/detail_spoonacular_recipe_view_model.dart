import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/data/providers/favourite_recipe_provider.dart';
import 'package:base_code_template_flutter/data/repositories/api/session/session_repository.dart';
import 'package:base_code_template_flutter/data/repositories/api/spoonacular/spoonacular_repository.dart';
import 'package:base_code_template_flutter/data/services/hive_storage/hive_storage.dart';
import 'package:base_code_template_flutter/screens/detail_recipe/detail_recipe_state.dart';
import 'package:base_code_template_flutter/screens/detail_recipe/detail_recipe_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/api/responses/nutrition/nutrients.dart';

class DetailSpoonacularRecipeViewModel
    extends DetailRecipeViewModel<DetailSpoonacularRecipeState> {
  DetailSpoonacularRecipeViewModel({
    required Ref ref,
    required FavouriteRecipeProvider favouriteRecipeProvider,
    required this.sessionRepository,
    required this.hiveStorage,
    required this.spoonacularRepository,
  }) : super(
            ref, favouriteRecipeProvider, const DetailSpoonacularRecipeState());
  final RecipeSpoonacularRepository spoonacularRepository;
  final SessionRepository sessionRepository;
  final HiveStorage hiveStorage;

  List<Recipe> listRecipeHistory = [];
  List<Nutrition> listNutritionsInRecipeHistory = [];
  List<List<Recipe>> listSimilarHistory = [];
  @override
  Future<void> initData(Recipe recipe) async {
    await getNewRecipe(recipe.id as int);
  }

  Future<void> getInfoRecipe(int id) async {
    final isCache = await _getCachedRecipe(id);
    if (!isCache) {
      await _getInfoRecipe(id);
    }
  }

  Future<void> getNewRecipe(int id) async {
    resetData();
    await Future.wait([
      getInfoRecipe(id),
      getSimilarRecipes(id),
      getNutritionInRecipe(id),
    ]);
    final recipe = state.recipe;
    final nutrition = state.nutrition;
    final listSimilar = state.similarRecipes;
    if (recipe != null) {
      listRecipeHistory.add(recipe);
    }
    if (nutrition != null) {
      listNutritionsInRecipeHistory.add(nutrition);
    }
    if (listSimilar != null && listSimilar.isNotEmpty) {
      listSimilarHistory.add(listSimilar);
    }
  }

  @override
  void resetData() {
    state = state.copyWith(nutrition: null, recipe: null, similarRecipes: null);
  }

  Future<bool> _getCachedRecipe(int id) async {
    var recipeResponse = sessionRepository.getRecipe(id);
    recipeResponse ??= await hiveStorage.readRecipe(id);
    if (recipeResponse != null) {
      state = state.copyWith(
        recipe: recipeResponse,
        listRecipe: state.listRecipe + [recipeResponse],
      );
    }
    return recipeResponse != null;
  }

  Future<void> _getInfoRecipe(int id) async {
    final recipeResponse = await spoonacularRepository.getInfoRecipe(id);
    state = state.copyWith(
      recipe: recipeResponse,
      listRecipe: state.listRecipe + [recipeResponse],
    );
    sessionRepository.saveRecipe(recipeResponse);
    hiveStorage.writeRecipe(recipeResponse);
  }

  Future<void> getSimilarRecipes(int id) async {
    bool hasCache = await _getCacheSimilarRecipes(id);
    if (!hasCache) {
      await (_getSimilarRecipes(id));
    }
  }

  Future<bool> _getCacheSimilarRecipes(int id) async {
    var response = sessionRepository.getSimilarRecipes(id);
    state = state.copyWith(
      similarRecipes: response,
    );
    return response != null;
  }

  Future<void> _getSimilarRecipes(int id) async {
    var reponse = await spoonacularRepository.getSimilarRecipes(id);
    state = state.copyWith(
      similarRecipes: reponse,
    );
    sessionRepository.saveSimilarRecipes(reponse);
  }

  Future<void> getNutritionInRecipe(int id) async {
    bool hasCache = await _getCachNutritionInRecipe(id);
    if (!hasCache) {
      await (_getNutritionInRecipe(id));
    }
  }

  Future<bool> _getCachNutritionInRecipe(int id) async {
    var response = sessionRepository.getNutritionInRecipe(id);
    if (response != null) {
      state = state.copyWith(
        nutrition: response,
      );
    }
    return response != null;
  }

  Future<void> _getNutritionInRecipe(int id) async {
    var response = await spoonacularRepository.getNutritionInRecipe(id);
    state = state.copyWith(
      nutrition: response,
    );
    sessionRepository.saveNutritionInRecipe(response);
  }

  @override
  void returnRecipeBefore() {
    if (listRecipeHistory.length > 1 &&
        listNutritionsInRecipeHistory.length > 1 &&
        listSimilarHistory.length > 1) {
      listRecipeHistory.removeLast();
      listNutritionsInRecipeHistory.removeLast();
      listSimilarHistory.removeLast();
      state = state.copyWith(
        recipe: listRecipeHistory.last,
        similarRecipes: listSimilarHistory.last,
        nutrition: listNutritionsInRecipeHistory.last,
      );
    }
  }
}
