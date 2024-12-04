import 'package:base_code_template_flutter/data/models/api/responses/nutrition/nutrients.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe_request.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipes_random_response.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/data/services/api/spoonacular/api_spoonacular_client.dart';

abstract class RecipeSpoonacularRepository {
  Future<RecipesRandomResponse> getRecipes(
    Map<String, dynamic> queries,
  );

  Future<List<Recipe>> getRandom(
    Map<String, dynamic> queries,
  );

  Future<Recipe> getInfoRecipe(
    int id,
  );

  Future<List<Recipe>?> getSimilarRecipes(
    int id,
  );

  Future<List<Ingredient>?> getCompleteIngredient(
    String search,
  );

  Future<Recipe> getAnalyzeRecipe(
    Recipe recipe,
  );

  Future<Nutrition> getNutritionInRecipe(
    int idRecipe,
  );
}

class RecipeSpoonacularRepositoryImpl implements RecipeSpoonacularRepository {
  RecipeSpoonacularRepositoryImpl(this._apiSpoonacularClient);

  final ApiSpoonacularClient _apiSpoonacularClient;

  @override
  Future<RecipesRandomResponse> getRecipes(
    Map<String, dynamic> queries,
  ) async {
    return await _apiSpoonacularClient.searchRecipes(queries);
  }

  @override
  Future<List<Recipe>> getRandom(
    Map<String, dynamic> queries,
  ) async {
    final response = await _apiSpoonacularClient.getRandomRecipes(queries);
    if (response.response.statusCode == 200) {
      final List<dynamic> jsonData = response.data;
      return jsonData
          .map((recipeJson) => SpooncularRecipe.fromJson(recipeJson))
          .toList();
    } else {
      // Handle the error
      throw Exception(
          'Error fetching similar recipes: ${response.response.statusCode}');
    }
  }

  @override
  Future<Recipe> getInfoRecipe(int id) async {
    final recipeReponse = await _apiSpoonacularClient.getInfoRecipe(id);
    if (recipeReponse.response.statusCode == 200) {
      return SpooncularRecipe.fromJson(recipeReponse.data);
    }
    throw Exception(
        'Error fetching recipes: ${recipeReponse.response.statusCode}');
  }

  @override
  Future<List<Recipe>?> getSimilarRecipes(
    int id,
  ) async {
    final response = await _apiSpoonacularClient.getSimilarRecipes(id);
    if (response.response.statusCode == 200) {
      final List<dynamic> jsonData = response.data;
      return jsonData
          .map((recipeJson) => SpooncularRecipe.fromJson(recipeJson))
          .toList();
    } else {
      // Handle the error
      throw Exception(
          'Error fetching similar recipes: ${response.response.statusCode}');
    }
  }

  @override
  Future<Nutrition> getNutritionInRecipe(
    int idRecipe,
  ) async {
    return await _apiSpoonacularClient.getNutritionInRecipe(idRecipe);
  }

  @override
  Future<List<Ingredient>?> getCompleteIngredient(String search) async {
    return await _apiSpoonacularClient.getIngredient(search, true);
  }

  @override
  Future<Recipe> getAnalyzeRecipe(
    Recipe recipe,
  ) async {
    List<String> listIngredient = [];
    for (var i in recipe.extendedIngredients.toList()) {
      String ingredient = "${i.amount} ${i.unit} ${i.name}";
      listIngredient.add(ingredient);
    }
    RecipeRequest request = RecipeRequest(
        title: recipe.title ?? "",
        servings: recipe.servings ?? 1,
        ingredients: listIngredient,
        instructions: recipe.instructions ?? '');
    final response = await _apiSpoonacularClient.getAnalyzeRecipe(request);
    Recipe recipeResponse = SpooncularRecipe.fromJson(response.data);
    recipe = recipe.copyWith(
        healthScore: recipeResponse.healthScore,
        spoonacularScore: recipeResponse.spoonacularScore,
        pricePerServing: recipeResponse.pricePerServing,
        cheap: recipeResponse.cheap,
        dairyFree: recipeResponse.dairyFree,
        gap: recipeResponse.gap,
        glutenFree: recipeResponse.glutenFree,
        ketogenic: recipeResponse.ketogenic,
        lowFodmap: recipeResponse.lowFodmap,
        sustainable: recipeResponse.sustainable,
        vegan: recipeResponse.vegan,
        vegetarian: recipeResponse.vegetarian,
        veryHealthy: recipeResponse.veryHealthy,
        veryPopular: recipeResponse.veryPopular,
        whole30: recipeResponse.whole30,
        dishTypes: recipeResponse.dishTypes);
    return recipe;
  }
}
