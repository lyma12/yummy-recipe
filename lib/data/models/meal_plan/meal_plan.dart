import 'package:base_code_template_flutter/data/models/api/responses/nutrition/nutrients.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_plan.freezed.dart';
part 'meal_plan.g.dart';

@freezed
class RequestMealPlanDay with _$RequestMealPlanDay {
  const factory RequestMealPlanDay({
    @Default(0) int? date,
    @Default(0) int? slot,
    @Default(0) int? position,
    String? type,
    ItemMealValue? value,
  }) = _RequestMealPlanDay;

  factory RequestMealPlanDay.fromJson(Map<String, dynamic> json) =>
      _$RequestMealPlanDayFromJson(json);
}

@freezed
class MealPlanDay with _$MealPlanDay {
  const factory MealPlanDay({
    @Default({}) Map<String, List<Nutrients>>? nutritionSummary,
    @Default({}) Map<String, List<Nutrients>>? nutritionSummaryBreakfast,
    @Default({}) Map<String, List<Nutrients>>? nutritionSummaryLunch,
    @Default({}) Map<String, List<Nutrients>>? nutritionSummaryDinner,
    int? date,
    String? day,
    @Default([]) List<ItemMeal>? items,
  }) = _MealPlanDay;

  factory MealPlanDay.fromJson(Map<String, dynamic> json) =>
      _$MealPlanDayFromJson(json);
}

@freezed
class MealPlanWeek with _$MealPlanWeek {
  const factory MealPlanWeek({
    @Default([]) List<MealPlanDay>? days,
  }) = _MealPlanWeek;

  factory MealPlanWeek.fromJson(Map<String, dynamic> json) =>
      _$MealPlanWeekFromJson(json);
}

@freezed
class ItemMeal with _$ItemMeal {
  const factory ItemMeal({
    int? id,
    int? slot,
    int? position,
    String? type,
    ItemMealValue? value,
  }) = _ItemMeal;

  factory ItemMeal.fromJson(Map<String, dynamic> json) =>
      _$ItemMealFromJson(json);
}

enum ItemMealType {
  recipe,
  customFood,
  ingredients,
  product,
}

@freezed
class ItemMealValue with _$ItemMealValue {
  const factory ItemMealValue({
    String? servings,
    String? id,
    String? title,
    String? imageType,
    String? image,
    List<Map<String, dynamic>>? ingredients,
  }) = _ItemMealValue;

  factory ItemMealValue.fromJson(Map<String, dynamic> json) =>
      _$ItemMealValueFromJson(json);
}
