import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe.dart';
import 'package:base_code_template_flutter/data/models/api/responses/user_comment/recipe_comment.dart';
import 'package:base_code_template_flutter/data/models/user/user_firebase_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

@freezed
sealed class Recipe with _$Recipe {
  @HiveType(typeId: 1, adapterName: 'FirebaseRecipeAdapter')
  const factory Recipe.firebase({
    @HiveField(0) required String id,
    @HiveField(1) String? summary,
    @HiveField(2) String? title,
    @HiveField(3) String? image,
    @HiveField(4) int? servings,
    @HiveField(5) int? readyInMinutes,
    @HiveField(6) int? cookingMinutes,
    @HiveField(7) double? healthScore,
    @HiveField(8) double? spoonacularScore,
    @HiveField(9) double? pricePerServing,
    @HiveField(10) bool? cheap,
    @HiveField(11) bool? dairyFree,
    @HiveField(12) String? gap,
    @HiveField(13) bool? glutenFree,
    @HiveField(14) String? instructions,
    @HiveField(15) bool? ketogenic,
    @HiveField(16) bool? lowFodmap,
    @HiveField(17) bool? sustainable,
    @HiveField(18) bool? vegan,
    @HiveField(19) bool? vegetarian,
    @HiveField(20) bool? veryHealthy,
    @HiveField(21) bool? veryPopular,
    @HiveField(22) bool? whole30,
    @HiveField(23) @Default([]) List<String> dishTypes,
    @HiveField(24) @Default([]) List<Ingredient> extendedIngredients,
    @HiveField(25) DateTime? timeStamp,
    @HiveField(26) UserFirebaseProfile? user,
    @HiveField(27) DateTime? createAt,
    @HiveField(28) @Default(0) int like,
    @HiveField(29) @Default([]) List<UserFirebaseProfile> peopleLike,
    @HiveField(30) @Default([]) List<RecipeComment> listComment,
  }) = FirebaseRecipe;

  @HiveType(typeId: 5, adapterName: 'SpooncularRecipeAdapter')
  const factory Recipe.spoonacular({
    @HiveField(0) required int id,
    @HiveField(1) String? summary,
    @HiveField(2) String? title,
    @HiveField(3) String? image,
    @HiveField(4) int? servings,
    @HiveField(5) int? readyInMinutes,
    @HiveField(6) int? cookingMinutes,
    @HiveField(7) double? healthScore,
    @HiveField(8) double? spoonacularScore,
    @HiveField(9) double? pricePerServing,
    @HiveField(10) bool? cheap,
    @HiveField(11) bool? dairyFree,
    @HiveField(12) String? gap,
    @HiveField(13) bool? glutenFree,
    @HiveField(14) String? instructions,
    @HiveField(15) bool? ketogenic,
    @HiveField(16) bool? lowFodmap,
    @HiveField(17) bool? sustainable,
    @HiveField(18) bool? vegan,
    @HiveField(19) bool? vegetarian,
    @HiveField(20) bool? veryHealthy,
    @HiveField(21) bool? veryPopular,
    @HiveField(22) bool? whole30,
    @HiveField(23) @Default([]) List<String> dishTypes,
    @HiveField(24) @Default([]) List<Ingredient> extendedIngredients,
    @HiveField(25) DateTime? timeStamp,
    @HiveField(26) int? preparationMinutes,
    @HiveField(27) String? license,
    @HiveField(28) String? sourceName,
    @HiveField(29) String? sourceUrl,
    @HiveField(30) String? spoonacularSourceUrl,
    @HiveField(31) String? creditsText,
    @HiveField(32) int? weightWatcherSmartPoints,
    @HiveField(33) String? imageType,
  }) = SpooncularRecipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}
