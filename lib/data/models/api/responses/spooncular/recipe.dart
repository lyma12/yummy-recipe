import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'recipe.freezed.dart';

part 'recipe.g.dart';

enum RecipeTagType {
  cheap,
  dairFree,
  glutenFree,
  lowFodmap,
  sustainable,
  vegan,
  vegetarian,
  veryHealthy,
  ketogenic,
  whole30
}

@HiveType(typeId: 2, adapterName: 'IngredientAdapter')
@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient({
    @HiveField(0) String? aisle,
    @HiveField(1) double? amount,
    @HiveField(2) String? consistency,
    @HiveField(3) int? id,
    @HiveField(4) String? image,
    @HiveField(5) @Default({}) Map<String, Measure?> measures,
    @HiveField(6) @Default([]) List<String> meta,
    @HiveField(7) String? name,
    @HiveField(8) String? original,
    @HiveField(9) String? originalName,
    @HiveField(10) String? unit,
    @HiveField(11) @Default([]) List<String>? possibleUnits,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}

@HiveType(typeId: 3, adapterName: 'MeasureAdapter')
@freezed
class Measure with _$Measure {
  const factory Measure({
    @HiveField(0) double? amount,
    @HiveField(1) String? unitLong,
    @HiveField(2) String? unitShort,
    @HiveField(3) String? unit,
  }) = _Measure;

  factory Measure.fromJson(Map<String, dynamic> json) =>
      _$MeasureFromJson(json);
}
