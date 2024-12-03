import 'package:base_code_template_flutter/components/base_view/base_view_model.dart';
import 'package:base_code_template_flutter/components/search_recipe/search_recipe_state.dart';
import 'package:base_code_template_flutter/data/providers/hive_storage_provider.dart';
import 'package:base_code_template_flutter/data/providers/recipe_repository_provider.dart';
import 'package:base_code_template_flutter/utilities/exceptions/extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/recipe/recipe.dart';
import '../../data/repositories/api/spoonacular/spoonacular_repository.dart';
import '../../data/repositories/firebase/recipe_firebase_store_repository.dart';
import '../../data/services/hive_storage/hive_storage.dart';

final searchRecipeProvider =
    StateNotifierProvider<SearchRecipeViewModel, SearchRecipeState>(
  (ref) => SearchRecipeViewModel(
    ref: ref,
    recipeFirebaseStoreRepository: ref.read(recipeFirebaseRepositoryProvider),
    spoonacularRepository: ref.read(recipeSpoonacularRepositoryProvider),
    hiveStorage: ref.read(hiveStorageProvider),
  ),
);

class SearchRecipeViewModel extends BaseViewModel<SearchRecipeState> {
  SearchRecipeViewModel({
    required this.ref,
    required this.recipeFirebaseStoreRepository,
    required this.spoonacularRepository,
    required this.hiveStorage,
  }) : super(const SearchRecipeState());
  final Ref ref;
  final RecipeSpoonacularRepository spoonacularRepository;
  final RecipeFirebaseStoreRepository recipeFirebaseStoreRepository;
  final HiveStorage hiveStorage;

  Future searchRecipe(String text) async {
    state = state.copyWith(
      listRecipe: [],
    );
    final queries = await getQueries(text);
    final response = await spoonacularRepository.getRecipes(queries);
    final responseFirebase =
        await recipeFirebaseStoreRepository.getRecipes(text);
    List<Recipe> listRecipe = [
      ...?responseFirebase,
      ...response.results,
    ];
    state = state.copyWith(
      listRecipe: listRecipe,
    );
  }

  void clear() {
    state = state.copyWith(
      selectRecipe: null,
      listRecipe: null,
    );
  }

  void updateListSelectRecipe(Recipe recipe) {
    state = state.copyWith(
      selectRecipe: [...?state.selectRecipe, recipe],
      listRecipe: null,
    );
  }

  Future<Map<String, dynamic>> getQueries(String text) async {
    Map<String, dynamic> queries = {
      "number": 6,
      "offset": 0,
      "query": text,
    };
    var userOptionQueries = await hiveStorage.readQueries();
    if (userOptionQueries != null) {
      queries.addAll(userOptionQueries.getMap());
    }
    return queries;
  }
}
