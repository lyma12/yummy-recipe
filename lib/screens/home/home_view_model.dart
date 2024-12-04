import 'dart:async';

import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/data/repositories/api/session/session_repository.dart';
import 'package:base_code_template_flutter/data/repositories/api/spoonacular/spoonacular_repository.dart';
import 'package:base_code_template_flutter/data/repositories/firebase/recipe_firebase_store_repository.dart';
import 'package:base_code_template_flutter/data/repositories/signin/signin_repository.dart';
import 'package:base_code_template_flutter/data/services/hive_storage/hive_storage.dart';
import 'package:base_code_template_flutter/screens/home/home_state.dart';
import 'package:base_code_template_flutter/utilities/exceptions/extension.dart';
import 'package:base_code_template_flutter/utilities/utilities.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/base_view/base_view_model.dart';
import '../../utilities/constants/firebae_recipe_field_name.dart';

class HomeViewModel extends BaseViewModel<HomeState> {
  HomeViewModel({
    required this.ref,
    required this.spoonacularRepository,
    required this.sessionRepository,
    required this.firebaseStoreResposity,
    required this.auth,
    required this.hiveStorage,
  }) : super(const HomeState());

  final Ref ref;
  final RecipeSpoonacularRepository spoonacularRepository;
  final RecipeFirebaseStoreRepository firebaseStoreResposity;
  final SessionRepository sessionRepository;
  final AuthRepository auth;
  final HiveStorage hiveStorage;
  final int numberRecipeGet = 6;
  int _offsetRecipes = 0;
  Stream<List<Recipe>>? _recipeStream;
  int _limitRecipes = 10;

  Future<void> initData() async {
    final queries = await getQueries();
    await Future.wait([
      _getRecipe(queries),
    ]);
    _listenToRecipes();
  }

  Future<Map<String, dynamic>> getQueries() async {
    Map<String, dynamic> queries = {
      "number": numberRecipeGet,
      "offset": _offsetRecipes,
    };
    var userOptionQueries = await hiveStorage.readQueries();
    if (userOptionQueries != null) {
      queries.addAll(userOptionQueries.getMap());
    }
    return queries;
  }

  TimeTypeInDay _getTimeNowInDay() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return TimeTypeInDay.morning; // morning
    } else if (hour >= 12 && hour < 17) {
      return TimeTypeInDay.afternoon; // Chiều
    } else if (hour >= 17 && hour < 21) {
      return TimeTypeInDay.evening; // Tối
    } else {
      return TimeTypeInDay.night; // Đêm
    }
  }

  String? getMessage(AppLocalizations? appLocalizations) {
    switch (_getTimeNowInDay()) {
      case TimeTypeInDay.morning:
        return appLocalizations?.good_1;
      case TimeTypeInDay.afternoon:
        return appLocalizations?.good_2;
      case TimeTypeInDay.evening:
        return appLocalizations?.good_3;
      default:
        return appLocalizations?.good_3;
    }
  }

  String? getMessageSuggest(AppLocalizations? appLocalizations) {
    switch (_getTimeNowInDay()) {
      case TimeTypeInDay.morning:
        return appLocalizations?.messeage_app_1;
      case TimeTypeInDay.afternoon:
        return appLocalizations?.messeage_app_2;
      case TimeTypeInDay.evening:
        return appLocalizations?.messeage_app_3;
      default:
        return appLocalizations?.messeage_app_3;
    }
  }

  Future<void> getMoreRecipe() async {
    final queries = await getQueries();
    await _getRecipe(queries);
  }

  Future<void> _getRecipe(Map<String, dynamic> queries) async {
    final hasCacheRecipes = await _getCachedRecipeList(_offsetRecipes);
    if (!hasCacheRecipes) {
      await _getRecipeResponseList(queries);
    }
  }

  Future<bool> _getCachedRecipeList(int offset) async {
    var recipeResponse = sessionRepository.recipesRandomResponse(offset);
    recipeResponse ??= await hiveStorage.readRecipesRandomResponse(offset);
    if (recipeResponse != null && recipeResponse.isNotEmpty) {
      state =
          state.copyWith(recipeList: [...state.recipeList, ...recipeResponse]);
      _offsetRecipes = _offsetRecipes + recipeResponse.length;
    }
    return recipeResponse != null && recipeResponse.isNotEmpty;
  }

  Future<void> _getRecipeResponseList(Map<String, dynamic> queries) async {
    final recipeResponse = await spoonacularRepository.getRecipes(queries);
    _offsetRecipes = recipeResponse.offset + recipeResponse.results.length;
    bool getTrue = recipeResponse.offset + 6 <= recipeResponse.number;
    state = state.copyWith(
      recipeList: state.recipeList + recipeResponse.results,
      getTrue: getTrue,
    );
    sessionRepository.saveRecipesRandomResponse(recipeResponse);
    hiveStorage.writeRecipesRandomResponse(recipeResponse);
  }

  bool isHasLike(Recipe recipe) {
    if (recipe is FirebaseRecipe) {
      final userId = auth.getUserProfile().id;
      return recipe.peopleLike.any((p) => p.id == userId);
    }
    return false;
  }

  Future<void> like(Recipe recipe) async {
    if (recipe is FirebaseRecipe) {
      final user = auth.getUserProfile();
      var listLiker = [...recipe.peopleLike];
      if (isHasLike(recipe)) {
        listLiker.removeWhere((liker) => liker.id == user.id);
      } else {
        listLiker.add(user);
      }
      recipe = recipe.copyWith(like: listLiker.length, peopleLike: listLiker);
      Map<String, dynamic> data = {
        FirebaseRecipeFieldName.like: recipe.like,
        FirebaseRecipeFieldName.peopleLike:
            Utilities.getUserPeopleLikeToFirebse(recipe.peopleLike),
      };
      firebaseStoreResposity.updateRecipes(data, recipe.id);
    }
  }

  void loadMoreRecipes() {
    _limitRecipes = (state.recipePostList?.length ?? 0) + 10;
    _recipeStream = firebaseStoreResposity.listenRecipesStream(_limitRecipes);
  }

  void _listenToRecipes() {
    _recipeStream = firebaseStoreResposity.listenRecipesStream(_limitRecipes);
    _recipeStream!.listen((recipes) {
      if (mounted) {
        state = state.copyWith(recipePostList: recipes);
      }
    });
  }
}

enum TimeTypeInDay {
  morning,
  afternoon,
  evening,
  night,
}
