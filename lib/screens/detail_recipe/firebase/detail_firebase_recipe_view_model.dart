import 'package:base_code_template_flutter/data/models/api/responses/user_comment/recipe_comment.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/data/providers/favourite_recipe_provider.dart';
import 'package:base_code_template_flutter/data/repositories/api/session/session_repository.dart';
import 'package:base_code_template_flutter/data/repositories/firebase/firebase_store_repository.dart';
import 'package:base_code_template_flutter/data/repositories/signin/signin_repository.dart';
import 'package:base_code_template_flutter/data/services/hive_storage/hive_storage.dart';
import 'package:base_code_template_flutter/screens/detail_recipe/detail_recipe_state.dart';
import 'package:base_code_template_flutter/screens/detail_recipe/detail_recipe_view_model.dart';
import 'package:base_code_template_flutter/utilities/constants/firebae_recipe_field_name.dart';
import 'package:base_code_template_flutter/utilities/utilities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailFirebaseRecipeViewModel
    extends DetailRecipeViewModel<DetailFirebaseRecipeState> {
  DetailFirebaseRecipeViewModel({
    required Ref ref,
    required FavouriteRecipeProvider favouriteRecipeProvider,
    required this.sessionRepository,
    required this.hiveStorageManager,
    required this.firebaseStoreRepository,
    required this.auth,
  }) : super(ref, favouriteRecipeProvider, const DetailFirebaseRecipeState());
  final FirebaseStoreRespository firebaseStoreRepository;
  final SessionRepository sessionRepository;
  final HiveStorage hiveStorageManager;
  Stream<Recipe>? _recipeStream;
  final AuthRepository auth;

  @override
  Future<void> initData(Recipe recipe) async {
    _listenToRecipes(recipe.id.toString());
  }

  @override
  void resetData() {
    state = state.copyWith(listComment: [], recipe: null);
  }

  void _listenToRecipes(String id) {
    _recipeStream = firebaseStoreRepository.listenRecipe(id);
    _recipeStream!.listen((recipe) {
      if (mounted) {
        state = state.copyWith(
          recipe: recipe,
          listComment: (recipe as FirebaseRecipe).listComment,
        );
      }
    });
  }

  Future<void> comment(String text) async {
    var recipe = state.recipe;
    if (recipe != null && recipe is FirebaseRecipe) {
      final comment = RecipeComment(
          user: auth.getUserProfile(), text: text, createAt: DateTime.now());
      recipe = recipe.copyWith(
        listComment: [...recipe.listComment, comment],
      );
      final data = Utilities.getListCommentToFirebase(recipe.listComment);

      Map<String, dynamic> updateData = {
        FirebaseRecipeFieldName.listComment: data,
      };
      firebaseStoreRepository.updateRecipes(updateData, recipe.id);
    }
  }

  bool isHasLike() {
    var recipe = state.recipe;
    if (recipe is FirebaseRecipe) {
      final userId = auth.getUserProfile().id;
      return recipe.peopleLike.any((p) => p.id == userId);
    }
    return false;
  }

  Future<void> like() async {
    var recipe = state.recipe;
    if (recipe != null && recipe is FirebaseRecipe) {
      final user = auth.getUserProfile();
      var listLiker = [...recipe.peopleLike];
      if (isHasLike()) {
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
      firebaseStoreRepository.updateRecipes(data, recipe.id);
    }
  }
}
