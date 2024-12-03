import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<Recipe> recipeList,
    @Default([]) List<Recipe> recipeRandom,
    @Default(true) bool getTrue,
    @Default(null) Recipe? recipe,
    @Default(null) List<Recipe>? similarRecipes,
    @Default([]) List<Recipe>? recipePostList,
  }) = _HomeState;

  const HomeState._();
}
