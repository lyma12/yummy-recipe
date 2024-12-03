import 'dart:io';

import 'package:base_code_template_flutter/components/base_view/base_view_model.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/data/models/user/user_firebase_profile.dart';
import 'package:base_code_template_flutter/data/repositories/api/session/session_repository.dart';
import 'package:base_code_template_flutter/data/repositories/api/spoonacular/spoonacular_repository.dart';
import 'package:base_code_template_flutter/data/repositories/firebase/firebase_storage_repository.dart';
import 'package:base_code_template_flutter/data/repositories/firebase/recipe_firebase_store_repository.dart';
import 'package:base_code_template_flutter/data/repositories/signin/signin_repository.dart';
import 'package:base_code_template_flutter/screens/create/create_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateViewModel extends BaseViewModel<CreateState> {
  CreateViewModel({
    required this.ref,
    required this.spoonacularRepository,
    required this.sessionRepository,
    required this.firebaseStorageRepository,
    required this.firebaseStoreRespository,
    required this.authRepository,
  }) : super(const CreateState());
  final Ref ref;
  final RecipeSpoonacularRepository spoonacularRepository;
  final SessionRepository sessionRepository;
  final FirebaseStorageRepository firebaseStorageRepository;
  final RecipeFirebaseStoreRepository firebaseStoreRespository;
  final AuthRepository authRepository;
  String _historySearch = "";

  Future<void> initData() async {
    await Future.wait([
      _initRecipe(),
    ]);
  }

  Future<void> getCompletedIngredient(String? search) async {
    if (search != null && !_historySearch.contains(search)) {
      _historySearch = search;
      final response =
          await spoonacularRepository.getCompleteIngredient(search);
      if (mounted) state = state.copyWith(listIngredientComplete: response);
    }
    if (mounted) state = state.copyWith(createRecipe: true);
  }

  void addToListIngredient(Ingredient ingredient) {
    final currentList = state.listIngredient ?? [];
    ingredient = ingredient.copyWith(
      amount: 1,
      unit: ingredient.possibleUnits![0],
    );
    final updatedList = [...currentList, ingredient];
    state = state.copyWith(
      listIngredient: updatedList,
      createRecipe: false,
    );
  }

  void saveIngredient(Ingredient ingredient, int index) {
    final currentList = List<Ingredient>.from(state.listIngredient ?? []);
    if (index >= 0 && index < currentList.length) {
      currentList[index] = ingredient;
      state = state.copyWith(
        listIngredient: currentList,
      );
    }
  }

  void undoRemoveIngredient(Ingredient ingredient, int index) {
    List<Ingredient> currentList =
        List<Ingredient>.from(state.listIngredient ?? []);
    currentList.insert(index, ingredient);
    if (index >= 0 && index < currentList.length) {
      state = state.copyWith(
        listIngredient: currentList,
      );
    }
  }

  void removeIngredient(int index) {
    List<Ingredient> currentList =
        List<Ingredient>.from(state.listIngredient ?? []);
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      state = state.copyWith(
        listIngredient: currentList,
      );
    }
  }

  Future<void> uploadRecipe() async {
    final recipeData = state.recipe;
    if (recipeData != null &&
        state.imageData != null &&
        recipeData is FirebaseRecipe) {
      state = state.copyWith(
          recipe: recipeData.copyWith(
        extendedIngredients: state.listIngredient ?? [],
      ));
      final url = await firebaseStorageRepository.saveRecipe(
          recipeData.id, state.imageData);
      final recipe = recipeData.copyWith(
        image: url,
        user: authRepository.getUserProfile(),
        createAt: DateTime.now(),
      );
      await firebaseStoreRespository.saveRecipePost(recipe).then((onValue) {
        resetData();
      });
    }
  }

  Future<void> resetData() async {
    final id = firebaseStoreRespository.getGenerationId();
    UserFirebaseProfile userProfile = authRepository.getUserProfile();
    state = state.copyWith(
      recipe:
          FirebaseRecipe(id: id, user: userProfile, like: 0, peopleLike: []),
      createRecipe: false,
      listIngredient: [],
      imageData: null,
      isUpload: false,
    );
  }

  Future<void> getAnalyzeRecipe() async {
    final stateRecipe = state.recipe;
    if (stateRecipe == null) {
      return;
    }
    final response = await spoonacularRepository.getAnalyzeRecipe(
      stateRecipe.copyWith(
        extendedIngredients: state.listIngredient ?? [],
      ),
    );

    state = state.copyWith(
      recipe: response,
      isUpload: true,
    );
  }

  Future<void> _initRecipe() async {
    final id = firebaseStoreRespository.getGenerationId();
    UserFirebaseProfile userProfile = authRepository.getUserProfile();
    state = state.copyWith(
      recipe:
          FirebaseRecipe(id: id, user: userProfile, like: 0, peopleLike: []),
      createRecipe: false,
      isUpload: false,
    );
  }

  void saveTitle(String? title) {
    state = state.copyWith(
      recipe: state.recipe?.copyWith(title: title),
    );
  }

  void saveServing(int? serving) {
    state = state.copyWith(
      recipe: state.recipe?.copyWith(
        servings: serving,
      ),
    );
  }

  void saveReadyInMinues(int? time) {
    state = state.copyWith(
      recipe: state.recipe?.copyWith(
        readyInMinutes: time,
      ),
    );
  }

  void saveCookingInMinues(int? time) {
    state = state.copyWith(
      recipe: state.recipe?.copyWith(
        readyInMinutes: time,
      ),
    );
  }

  void saveSummary(String? summary) {
    state = state.copyWith(recipe: state.recipe?.copyWith(summary: summary));
  }

  void saveInstructions(String? instructions) {
    state = state.copyWith(
      recipe: state.recipe?.copyWith(
        instructions: instructions,
      ),
    );
  }

  void saveImage(File? image) {
    state = state.copyWith(
      imageData: image,
    );
  }
}
