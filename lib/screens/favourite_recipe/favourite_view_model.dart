import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/data/providers/favourite_recipe_provider.dart';
import 'package:base_code_template_flutter/data/services/hive_storage/hive_storage.dart';
import 'package:base_code_template_flutter/screens/favourite_recipe/favourite_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/base_view/base_view_model.dart';

class FavouriteViewModel extends BaseViewModel<FavouriteState> {
  FavouriteViewModel(
      {required this.hiveStorage,
      required this.ref,
      required this.favouriteRecipeNotifier})
      : super(const FavouriteState());
  final HiveStorage hiveStorage;
  final Ref ref;
  final FavouriteRecipeProvider favouriteRecipeNotifier;

  Future<void> initData() async {}

  Future<void> removeRecipe(Recipe recipe) async {
    await favouriteRecipeNotifier.removeFavouriteRecipe(recipe);
  }
}
