import 'package:base_code_template_flutter/data/models/api/responses/nutrition/nutrients.dart';
import 'package:base_code_template_flutter/data/models/api/responses/user_comment/recipe_comment.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'detail_recipe_state.freezed.dart';

@freezed
sealed class DetailRecipeState with _$DetailRecipeState {
  const factory DetailRecipeState.spoonacular({
    @Default(null) Recipe? recipe,
    @Default([]) List<Recipe>? similarRecipes,
    @Default(null) Nutrition? nutrition,
    @Default([]) List<Recipe> listRecipe,
  }) = DetailSpoonacularRecipeState;

  const factory DetailRecipeState.firebase({
    @Default(null) Recipe? recipe,
    @Default([]) List<RecipeComment> listComment,
  }) = DetailFirebaseRecipeState;

  const DetailRecipeState._();
}
