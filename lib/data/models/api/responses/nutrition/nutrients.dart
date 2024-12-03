import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nutrients.freezed.dart';

part 'nutrients.g.dart';

@freezed
class Nutrients with _$Nutrients {
  const factory Nutrients({
    String? name,
    double? amount,
    String? unit,
    double? percentOfDailyNeeds,
  }) = _Nutrients;

  factory Nutrients.fromJson(Map<String, dynamic> json) =>
      _$NutrientsFromJson(json);
}

@freezed
class Properties with _$Properties {
  const factory Properties({
    String? name,
    double? amount,
    String? unit,
  }) = _Properties;

  factory Properties.fromJson(Map<String, dynamic> json) =>
      _$PropertiesFromJson(json);
}

@freezed
class Flasvonoids with _$Flasvonoids {
  const factory Flasvonoids({
    String? name,
    double? amount,
    String? unit,
  }) = _Flasvonoids;

  factory Flasvonoids.fromJson(Map<String, dynamic> json) =>
      _$FlasvonoidsFromJson(json);
}

@freezed
class Caloricbreakdown with _$Caloricbreakdown {
  const factory Caloricbreakdown({
    double? percentProtein,
    double? percentFat,
    double? percentCarbs,
  }) = _Caloricbreakdown;

  factory Caloricbreakdown.fromJson(Map<String, dynamic> json) =>
      _$CaloricbreakdownFromJson(json);
}

@freezed
class WeightPerServing with _$WeightPerServing {
  const factory WeightPerServing({
    double? amount,
    String? unit,
  }) = _WeightPerServing;

  factory WeightPerServing.fromJson(Map<String, dynamic> json) =>
      _$WeightPerServingFromJson(json);
}

@freezed
class Nutrition with _$Nutrition {
  const factory Nutrition({
    @Default([]) List<Nutrients> nutrients,
    @Default([]) List<Properties> properties,
    @Default([]) List<Flasvonoids> flasvonoids,
    @Default([]) List<Ingredient> ingredients,
    Caloricbreakdown? caloricBreakdown,
    WeightPerServing? weightPerServing,
  }) = _Nutrition;

  factory Nutrition.fromJson(Map<String, dynamic> json) =>
      _$NutritionFromJson(json);
}
