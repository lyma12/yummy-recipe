import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/router/app_router.dart';

import '../data/models/recipe/recipe.dart';

class DetailRecipeRoute {
  const DetailRecipeRoute({required this.recipe});

  final Recipe recipe;

  PageRouteInfo route() {
    switch (recipe) {
      case FirebaseRecipe():
        return DetailFirebaseRecipeRoute(recipe: recipe);
      case SpooncularRecipe():
        return DetailSpoonacularRecipeRoute(recipe: recipe);
    }
  }
}
