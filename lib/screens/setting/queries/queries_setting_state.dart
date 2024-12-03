import 'package:base_code_template_flutter/data/models/queries/queries.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'queries_setting_state.freezed.dart';

@freezed
class QueriesSettingState with _$QueriesSettingState {
  const factory QueriesSettingState({
    Queries? queries,
    @Default(Cuisine.none) Cuisine cuisine,
    @Default([]) List<bool> mealTypes,
    @Default([]) List<bool> diets,
    @Default([]) List<bool> intolerances,
  }) = _QueriesSettingState;

  factory QueriesSettingState.initial() {
    return QueriesSettingState(
      mealTypes: List<bool>.filled(MealType.values.length, false),
      diets: List<bool>.filled(Diet.values.length, false),
      intolerances: List<bool>.filled(Intolerance.values.length, false),
    );
  }

  const QueriesSettingState._();
}
