import 'package:base_code_template_flutter/components/base_view/base_view_model.dart';
import 'package:base_code_template_flutter/data/services/hive_storage/hive_storage.dart';
import 'package:base_code_template_flutter/screens/setting/queries/queries_setting_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/queries/queries.dart';

class QueriesSettingViewModel extends BaseViewModel<QueriesSettingState> {
  QueriesSettingViewModel({
    required this.ref,
    required this.hiveStorage,
  }) : super(QueriesSettingState.initial());

  final Ref ref;
  final HiveStorage hiveStorage;

  List<Diet> dietOptions = Diet.values;
  List<Cuisine> cuisineOptions = Cuisine.values;
  List<MealType> mealTypeOptions = MealType.values;
  List<Intolerance> intoleranceOptions = Intolerance.values;

  void setCuisine(Cuisine? newCuisine) {
    if (newCuisine != null) {
      state = state.copyWith(
        cuisine: newCuisine,
      );
    }
  }

  List<bool> toggleOption(List<bool> options, int index) {
    if (index < options.length) {
      final updatedOptions = List<bool>.from(options);
      updatedOptions[index] = !updatedOptions[index];
      return updatedOptions;
    }
    return options;
  }

  void setMealType(int index) {
    List<bool> mealType = toggleOption(state.mealTypes, index);
    state = state.copyWith(
      mealTypes: mealType,
    );
  }

  void setDiet(int index) {
    List<bool> diet = toggleOption(state.diets, index);
    state = state.copyWith(
      diets: diet,
    );
  }

  void setIntolerance(int index) {
    List<bool> intolerance = toggleOption(state.intolerances, index);
    state = state.copyWith(
      intolerances: intolerance,
    );
  }

  Future<void> saveData() async {
    final queries = state.queries ?? const Queries();

    final selectedDiets = _getSelectedOptions(state.diets, Diet.values);
    final selectedMealTypes =
        _getSelectedOptions(state.mealTypes, MealType.values);
    final selectedIntolerances =
        _getSelectedOptions(state.intolerances, Intolerance.values);

    final newQueries = queries.copyWith(
      diet: selectedDiets,
      type: selectedMealTypes,
      intolerances: selectedIntolerances,
    );
    await hiveStorage.saveQueries(newQueries);
  }

  List<T> _getSelectedOptions<T>(List<bool> options, List<T> values) {
    return [
      for (int i = 0; i < options.length; i++)
        if (options[i]) values[i],
    ];
  }

  Future<void> initData() async {
    final queries = await hiveStorage.readQueries() ?? const Queries();

    state = state.copyWith(
      queries: queries,
      diets: _initStatus(Diet.values, queries.diet),
      mealTypes: _initStatus(MealType.values, queries.type),
      intolerances: _initStatus(Intolerance.values, queries.intolerances),
    );
  }

  List<bool> _initStatus(List<dynamic> options, List<dynamic>? selected) {
    final status = List<bool>.filled(options.length, false);
    selected?.forEach((item) {
      final index = options.indexOf(item);
      if (index != -1) {
        status[index] = true;
      }
    });
    return status;
  }
}
