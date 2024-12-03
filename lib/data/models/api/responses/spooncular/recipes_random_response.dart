import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'recipes_random_response.freezed.dart';
part 'recipes_random_response.g.dart';

@HiveType(typeId: 4, adapterName: 'RecipesRandomResponseAdapter')
@freezed
class RecipesRandomResponse with _$RecipesRandomResponse {
  const factory RecipesRandomResponse({
    @HiveField(0) required int number,
    @HiveField(1) @Default(0) int offset,
    @HiveField(2) @Default(0) int totalResults,
    @HiveField(3) @Default([]) List<SpooncularRecipe> results,
    @HiveField(4) DateTime? timeStamp,
  }) = _RecipesRandomResponse;

  factory RecipesRandomResponse.fromJson(Map<String, dynamic> json) =>
      _$RecipesRandomResponseFromJson(json);
}
