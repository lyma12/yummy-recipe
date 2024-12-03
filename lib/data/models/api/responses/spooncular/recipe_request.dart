import 'package:json_annotation/json_annotation.dart';

part 'recipe_request.g.dart';

@JsonSerializable()
class RecipeRequest {
  final String title;
  final int servings;
  final List<String> ingredients;
  final String instructions;

  RecipeRequest({
    required this.title,
    required this.servings,
    required this.ingredients,
    required this.instructions,
  });

  factory RecipeRequest.fromJson(Map<String, dynamic> json) =>
      _$RecipeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeRequestToJson(this);
}
