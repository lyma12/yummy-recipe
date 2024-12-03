import 'dart:async';
import 'package:base_code_template_flutter/data/models/meal_plan/factory_request_meal_plan_day.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/data/models/user/spoonacular_account.dart';
import 'package:base_code_template_flutter/data/providers/favourite_recipe_provider.dart';
import 'package:base_code_template_flutter/data/services/hive_storage/hive_storage.dart';
import 'package:base_code_template_flutter/screens/favourite_recipe/favourite_state.dart';
import 'package:base_code_template_flutter/screens/meal_plan/calendar/calendar_screen.dart';
import 'package:base_code_template_flutter/screens/meal_plan/calendar/calendar_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../components/base_view/base_view_model.dart';
import '../../components/internet/internet_provider.dart';
import '../../data/models/meal_plan/meal_plan.dart';
import '../../data/repositories/api/spoonacular/spoonacular_repository.dart';
import '../../data/repositories/firebase/user_firebase_store_repository.dart';
import '../../data/repositories/signin/signin_repository.dart';
import '../../data/services/secure_storage/secure_storage_manager.dart';
import '../../utilities/exceptions/spoonacular_exception.dart';

class FavouriteViewModel extends BaseViewModel<FavouriteState> {
  FavouriteViewModel({
    required this.hiveStorage,
    required this.ref,
    required this.favouriteRecipeNotifier,
    required this.spoonacularRepository,
    required this.firebaseAuth,
    required this.secureStorageManager,
    required this.userFirebaseRepository,
  }) : super(const FavouriteState());
  final HiveStorage hiveStorage;
  final Ref ref;
  final FavouriteRecipeProvider favouriteRecipeNotifier;
  final RecipeSpoonacularRepository spoonacularRepository;
  final SecureStorageManager secureStorageManager;
  final AuthRepository firebaseAuth;
  final UserProfileRepository userFirebaseRepository;

  bool get internetConnect => ref.watch(internetProvider);

  CalendarViewModel get mealPlanViewModel =>
      ref.read(mealPlanProvider.notifier);

  Future<void> initData() async {
    ref.read(internetProvider.notifier).startListeningToConnectivity();
  }

  Future<SpoonacularAccount?> _getSpoonacularAccount() async {
    final userId = firebaseAuth.getUserCredential().uid;
    final user = await secureStorageManager.readSpoonacularAccount(userId) ??
        await _getSpoonacularAccountFirebase(userId);
    return user;
  }

  Future<SpoonacularAccount> _getSpoonacularAccountFirebase(String uid) async {
    final user = await userFirebaseRepository.getSpoonacularAccount(uid);
    if (user != null) {
      await secureStorageManager.writeSpoonacularAccount(user);
      return user;
    } else {
      throw SpoonacularConnectException();
    }
  }

  Future addMealPlanDay(DateTime date, int timeOfDate, Recipe recipe) async {
    final userFirebase = await _getSpoonacularAccount();
    if (internetConnect) {
      if (userFirebase == null) throw SpoonacularConnectException();
      RequestMealPlanDay planDay =
          FactoryRequestMealPlanDay.factory(recipe, date, timeOfDate)
              .getRequestMealPlanDay();
      await spoonacularRepository.addMealPlanDay(userFirebase, planDay);
    } else {
      throw DioException.connectionError(
        reason: 'internet error connect!',
        requestOptions: RequestOptions(),
      );
    }
  }

  Future<void> removeRecipe(Recipe recipe) async {
    await favouriteRecipeNotifier.removeFavouriteRecipe(recipe);
  }
}
