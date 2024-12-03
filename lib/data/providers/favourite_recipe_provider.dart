import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/data/providers/hive_storage_provider.dart';
import 'package:base_code_template_flutter/data/services/hive_storage/hive_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favouriteRecipeProvider =
    StateNotifierProvider<FavouriteRecipeProvider, List<Recipe>>((ref) {
  return FavouriteRecipeProvider(ref.read(hiveStorageProvider));
});

class FavouriteRecipeProvider extends StateNotifier<List<Recipe>> {
  FavouriteRecipeProvider(this.hiveStorage) : super([]) {
    _loadFavouriteRecipes();
  }

  final HiveStorage hiveStorage;

  Future<void> _loadFavouriteRecipes() async {
    final recipes = await hiveStorage.readSaveRecipe() ?? [];
    state = recipes;
  }

  Future<void> addFavouriteRecipe(Recipe recipe) async {
    if (state.contains(recipe)) {
      return;
    }
    state = [...state, recipe];
    await hiveStorage.writeSaveRecipe(recipe);
  }

  Future<void> removeFavouriteRecipe(Recipe recipe) async {
    if (state.contains(recipe)) {
      return;
    }
    state = state.where((r) => r.id != recipe.id).toList();
    await hiveStorage.deleteSaveRecipe(recipe);
  }
}
