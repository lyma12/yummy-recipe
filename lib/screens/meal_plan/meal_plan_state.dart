import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/user/spoonacular_account.dart';

part 'meal_plan_state.freezed.dart';

@freezed
class MealPlanState with _$MealPlanState {
  const factory MealPlanState({
    SpoonacularAccount? user,
    @Default(false) bool isConnectSpoonacular,
  }) = _CalendarState;

  const MealPlanState._();
}
