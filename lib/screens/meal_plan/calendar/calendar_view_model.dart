import 'dart:async';

import 'package:base_code_template_flutter/components/internet/internet_provider.dart';
import 'package:base_code_template_flutter/data/models/api/responses/nutrition/nutrients.dart';
import 'package:base_code_template_flutter/data/models/meal_plan/factory_request_meal_plan_day.dart';
import 'package:base_code_template_flutter/data/models/meal_plan/meal_plan.dart';
import 'package:base_code_template_flutter/data/repositories/api/spoonacular/spoonacular_repository.dart';
import 'package:base_code_template_flutter/data/repositories/firebase/recipe_firebase_store_repository.dart';
import 'package:base_code_template_flutter/data/repositories/signin/signin_repository.dart';
import 'package:base_code_template_flutter/screens/meal_plan/calendar/calendar_state.dart';
import 'package:base_code_template_flutter/utilities/exceptions/spoonacular_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/base_view/base_view_model.dart';
import '../../../data/models/recipe/recipe.dart';
import '../../../data/models/user/spoonacular_account.dart';
import '../../../data/services/hive_storage/hive_storage.dart';
import '../../../data/services/secure_storage/secure_storage_manager.dart';

class CalendarViewModel extends BaseViewModel<CalendarState> {
  CalendarViewModel({
    required this.ref,
    required this.firebaseAuth,
    required this.spoonacularRepository,
    required this.hiveStorage,
    required this.secureStorageManager,
    required this.recipeFirebaseStoreRepository,
  }) : super(const CalendarState());

  final Ref ref;
  final AuthRepository firebaseAuth;
  final RecipeSpoonacularRepository spoonacularRepository;
  SpoonacularAccount? userFirebase;
  final SecureStorageManager secureStorageManager;
  final HiveStorage hiveStorage;
  final RecipeFirebaseStoreRepository recipeFirebaseStoreRepository;
  bool get internetConnect => ref.watch(internetProvider);
  final nutritionSummaryType = [
    "Nutrition summary day",
    "Nutrition summary breakfast",
    "Nutrition summary lunch",
    "Nutrition summary dinner",
  ];

  Future<void> initData(SpoonacularAccount user) async {
    ref.read(internetProvider.notifier).startListeningToConnectivity();
    userFirebase = user;
    final firstDateSelect = DateTime.now();
    await getMealPlanDay(firstDateSelect, user);
    state = state.copyWith(
      selectedDay: DateTime.now(),
      focusedDay: DateTime.now(),
      nutritionType: nutritionSummaryType.first,
    );
  }

  DateTime getStartOfWeek(DateTime date, {bool startOnMonday = true}) {
    int daysToSubtract = startOnMonday ? date.weekday - 1 : date.weekday;
    return date.subtract(Duration(days: daysToSubtract));
  }

  Future getMealPlanDay(DateTime date, SpoonacularAccount user) async {
    final isCache = await _getDataInStorage(date);
    if (isCache) {
      unawaited(_getMealPlanDay(date, user));
    } else {
      await _getMealPlanDay(date, user);
    }
  }

  Future _getMealPlanDay(DateTime date, SpoonacularAccount user) async {
    final response = await spoonacularRepository.getMealPlanDay(user, date);
    if (response != null) await secureStorageManager.writeMealPlanDay(response);
    state = state.copyWith(
      mealPlanDaySelect: response,
      nutritionType: nutritionSummaryType.first,
      nutritionSummary: response?.nutritionSummary?["nutrients"] ?? [],
    );
  }

  Future<bool> _getDataInStorage(DateTime date) async {
    final dataCache = await secureStorageManager.readMealPlanDay(date);
    if (dataCache != null) {
      state = state.copyWith(
        mealPlanDaySelect: dataCache,
        nutritionType: nutritionSummaryType.first,
        nutritionSummary: dataCache.nutritionSummary?["nutrients"] ?? [],
      );
      return true;
    }
    return false;
  }

  Future getMealPlanWeek(DateTime startDate, SpoonacularAccount user) async {
    final response =
        await spoonacularRepository.getMealPlanWeek(user, startDate);
    state = state.copyWith(
      mealPlan: response,
    );
  }

  Future selectDay(DateTime selectDay, DateTime focusedDay) async {
    if (userFirebase == null) return;
    await getMealPlanDay(selectDay, userFirebase!).catchError((error) {
      if (error is SpoonacularException && error.code == 2) {
        state = state.copyWith(
          selectedDay: selectDay,
          focusedDay: focusedDay,
          mealPlanDaySelect: null,
          nutritionType: nutritionSummaryType.first,
          nutritionSummary: [],
        );
      } else {
        throw error;
      }
    });
    state = state.copyWith(
      selectedDay: selectDay,
      focusedDay: focusedDay,
    );
  }

  Future addMealPlanDay(DateTime date, int timeOfDate, List<Recipe> recipes) async {
    if (internetConnect) {
      if (userFirebase == null) throw SpoonacularConnectException();
      if (userFirebase != null) {
        List<RequestMealPlanDay> request = [];
        for(var recipe in recipes){
          RequestMealPlanDay planDay =
          FactoryRequestMealPlanDay.factory(recipe, date, timeOfDate)
              .getRequestMealPlanDay();
          request.add(planDay);
        }
        await spoonacularRepository.addMealPlansDay(userFirebase!, request).then((_) async {
          await getMealPlanDay(date, userFirebase!);
        });
      }
    } else {
      throw DioException.connectionError(
          reason: 'internet error connect!', requestOptions: RequestOptions());
    }
  }
  
  Future updateShoppingList(DateTime dateTime) async {
    if(internetConnect){
      if(userFirebase == null) throw SpoonacularConnectException();
      await spoonacularRepository.generateShoppingList(userFirebase!, dateTime, dateTime);
    }else {
      throw DioException.connectionError(
          reason: 'internet error connect!', requestOptions: RequestOptions());
    }
  }

  void chooseNutritionType(int selectNutritionType) {
    List<Nutrients> nutritionSummary = [];
    switch (selectNutritionType) {
      case 1:
        nutritionSummary =
            state.mealPlanDaySelect?.nutritionSummaryBreakfast?["nutrients"] ??
                [];
        break;
      case 2:
        nutritionSummary =
            state.mealPlanDaySelect?.nutritionSummaryLunch?["nutrients"] ?? [];
        break;
      case 3:
        nutritionSummary =
            state.mealPlanDaySelect?.nutritionSummaryDinner?["nutrients"] ?? [];
        break;
      default:
        nutritionSummary =
            state.mealPlanDaySelect?.nutritionSummary?["nutrients"] ?? [];
        break;
    }
    state = state.copyWith(
      nutritionSummary: nutritionSummary,
      nutritionType: nutritionSummaryType[selectNutritionType],
    );
  }

  Future removeItemMealPlanDay(int id) async {
    if (internetConnect) {
      if (userFirebase == null) throw SpoonacularConnectException();
      await spoonacularRepository
          .deleteItemFromMealPlan(userFirebase!, id)
          .then((_) async {
        await _updateMealPlan();
      });
    } else {
      throw DioException.connectionError(
          reason: 'internet error connect!', requestOptions: RequestOptions());
    }
  }

  Future reLoad() async {
    final user = userFirebase;
    if (user == null) return;
    final selectDate = state.selectedDay ?? DateTime.now();
    await getMealPlanDay(selectDate, user);
  }

  Future _updateMealPlan() async {
    final date = state.selectedDay;
    if (date == null) return;
    await spoonacularRepository
        .getMealPlanDay(userFirebase!, date)
        .then((value) {
      state = state.copyWith(
        mealPlanDaySelect: value,
        nutritionType: nutritionSummaryType.first,
        nutritionSummary: value?.nutritionSummary?["nutrients"] ?? [],
      );
    }).catchError(
      (error) {
        if (error is SpoonacularException && error.code == 2) {
          state = state.copyWith(
            mealPlanDaySelect: null,
            nutritionType: nutritionSummaryType.first,
            nutritionSummary: [],
          );
        } else {
          throw error;
        }
      },
    );
  }
}
