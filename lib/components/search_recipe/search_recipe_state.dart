import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/recipe/recipe.dart';

part 'search_recipe_state.freezed.dart';

@freezed
class SearchRecipeState with _$SearchRecipeState {
  const factory SearchRecipeState({
    @Default([]) List<Recipe>? listRecipe,
    @Default([]) List<Recipe>? selectRecipe,
  }) = _SearchRecipeState;

  const SearchRecipeState._();
}
