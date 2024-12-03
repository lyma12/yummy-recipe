import 'package:base_code_template_flutter/data/models/api/responses/nutrition/nutrients.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/meal_plan/meal_plan.dart';
import '../../../data/models/recipe/recipe.dart';

part 'calendar_state.freezed.dart';

@freezed
class CalendarState with _$CalendarState {
  const factory CalendarState({
    DateTime? selectedDay,
    DateTime? focusedDay,
    MealPlanWeek? mealPlan,
    MealPlanDay? mealPlanDaySelect,
    @Default([]) List<Nutrients> nutritionSummary,
    String? nutritionType,
    @Default([]) List<Recipe> listSearchRecipe,
  }) = _CalendarState;

  const CalendarState._();
}
