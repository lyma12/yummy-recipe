import 'package:base_code_template_flutter/data/models/api/responses/nutrition/nutrients.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spoonacular/user_spoonacular/user_spoonacular_request.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe_request.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipes_random_response.dart';
import 'package:base_code_template_flutter/data/models/meal_plan/meal_plan.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/data/models/shopping_list/shopping_list.dart';
import 'package:base_code_template_flutter/data/models/user/spoonacular_account.dart';
import 'package:base_code_template_flutter/data/services/api/spoonacular/api_spoonacular_client.dart';
import 'package:base_code_template_flutter/utilities/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../utilities/exceptions/spoonacular_exception.dart';

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

  Future connectUser(
    User user,
    Function(
      String? hash,
      String? password,
      String? userName,
    ) saveHashUserSpoonacular,
  );

  Future<MealPlanDay?> getMealPlanDay(
    SpoonacularAccount user,
    DateTime date,
  );

  Future<MealPlanWeek?> getMealPlanWeek(
    SpoonacularAccount user,
    DateTime startDate,
  );

  Future addMealPlanDay(
    SpoonacularAccount user,
    RequestMealPlanDay? planDay,
  );

  Future addMealPlansDay(
    SpoonacularAccount user,
    List<RequestMealPlanDay> playDay,
  );

  Future clearMealPlanDay(
    SpoonacularAccount user,
    DateTime date,
  );

  Future deleteItemFromMealPlan(
    SpoonacularAccount user,
    int id,
  );

  Future<ShoppingList?> getShoppingList(
    SpoonacularAccount user,
  );

  Future addShoppingList(
    SpoonacularAccount user,
    ItemShoppingListRequest request,
  );

  Future generateShoppingList(
    SpoonacularAccount user,
    DateTime startDate,
    DateTime endDate,
  );

  Future deleteFromShoppingList(
    SpoonacularAccount user,
    int id,
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

  @override
  Future connectUser(
    User user,
    Function(
      String? hash,
      String? password,
      String? userName,
    ) saveHashUserSpoonacular,
  ) async {
    UserSpoonacularRequest request = UserSpoonacularRequest(
      username: user.displayName ?? "",
      lastname: user.displayName ?? "",
      firstname: user.displayName ?? "",
      email: user.email ?? "",
    );
    final response = await _apiSpoonacularClient.connectUser(request);
    await saveHashUserSpoonacular(
        response.hash, response.spoonacularPassword, response.username);
  }

  _UserInfo checkUserConnectSpoonacular(
    SpoonacularAccount user,
  ) {
    final userName = user.userNameSpoonacular;
    final hash = user.hash;
    if (userName == null || userName.isEmpty) {
      throw SpoonacularConnectException(
          message: 'please connect user spoonacular');
    }
    if (hash == null || hash.isEmpty) throw SpoonacularConnectException();
    return _UserInfo(userName: userName, hash: hash);
  }

  @override
  Future addMealPlanDay(
    SpoonacularAccount user,
    RequestMealPlanDay? planDay,
  ) async {
    _UserInfo info = checkUserConnectSpoonacular(user);
    var request = planDay?.toJson() ?? {};
    request['value'] = planDay?.value?.toJson();
    await _apiSpoonacularClient.addMealPlan(
      info.userName,
      info.hash,
      request,
    );
  }

  @override
  Future addShoppingList(
    SpoonacularAccount user,
    ItemShoppingListRequest request,
  ) async {
    _UserInfo info = checkUserConnectSpoonacular(user);
    await _apiSpoonacularClient.addShoppingList(
      info.userName,
      info.hash,
      request.toJson(),
    );
  }

  @override
  Future clearMealPlanDay(
    SpoonacularAccount user,
    DateTime date,
  ) async {
    _UserInfo info = checkUserConnectSpoonacular(user);
    await _apiSpoonacularClient.clearMealPlanDay(
      info.userName,
      Utilities.formatDateTimeSpoonacular(date),
      info.hash,
    );
  }

  @override
  Future deleteFromShoppingList(
    SpoonacularAccount user,
    int id,
  ) async {
    _UserInfo info = checkUserConnectSpoonacular(user);
    await _apiSpoonacularClient.deleteFromShoppingList(
      info.userName,
      id,
      info.hash,
    );
  }

  @override
  Future<MealPlanDay?> getMealPlanDay(
      SpoonacularAccount user, DateTime date) async {
    _UserInfo info = checkUserConnectSpoonacular(user);
    return await _apiSpoonacularClient
        .getMealPlanDay(
          info.userName,
          Utilities.formatDateTimeSpoonacular(date),
          info.hash,
        )
        .catchError((error) => throw SpoonacularNoMealPlanDay());
  }

  @override
  Future<MealPlanWeek?> getMealPlanWeek(
      SpoonacularAccount user, DateTime startDate) async {
    _UserInfo info = checkUserConnectSpoonacular(user);
    return await _apiSpoonacularClient
        .getMealPlanWeek(
          info.userName,
          Utilities.formatDateTimeSpoonacular(startDate),
          info.hash,
        )
        .catchError((error) => throw SpoonacularNoMealPlanWeek());
  }

  @override
  Future<ShoppingList?> getShoppingList(SpoonacularAccount user) async {
    _UserInfo info = checkUserConnectSpoonacular(user);
    return await _apiSpoonacularClient
        .getShoppingList(
          info.userName,
          info.hash,
        )
        .catchError((error) => throw SpoonacularNoShoppingList());
  }

  @override
  Future deleteItemFromMealPlan(
    SpoonacularAccount user,
    int id,
  ) async {
    _UserInfo info = checkUserConnectSpoonacular(user);
    await _apiSpoonacularClient.deleteItemFromMealPlan(
        info.userName, id, info.hash);
  }

  @override
  Future addMealPlansDay(
      SpoonacularAccount user, List<RequestMealPlanDay> playDay) async {
    _UserInfo info = checkUserConnectSpoonacular(user);
    await _apiSpoonacularClient.addMealPlans(
      info.userName,
      info.hash,
      playDay,
    );
  }

  @override
  Future generateShoppingList(
      SpoonacularAccount user, DateTime startDate, DateTime endDate) async {
    _UserInfo info = checkUserConnectSpoonacular(user);
    return await _apiSpoonacularClient
        .generateShoppingList(
          info.userName,
          info.hash,
          Utilities.formatDateTimeSpoonacular(startDate),
          Utilities.formatDateTimeSpoonacular(endDate),
        )
        .catchError((error) => throw SpoonacularNoShoppingList());
  }
}

class _UserInfo {
  const _UserInfo({required this.userName, required this.hash});

  final String userName;
  final String hash;
}
