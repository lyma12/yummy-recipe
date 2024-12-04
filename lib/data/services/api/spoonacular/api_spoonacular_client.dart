import 'package:base_code_template_flutter/data/models/api/responses/nutrition/nutrients.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spoonacular/user_spoonacular/user_spoonacular_response.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe_request.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipes_random_response.dart';
import 'package:base_code_template_flutter/data/models/meal_plan/meal_plan.dart';
import 'package:base_code_template_flutter/utilities/constants/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/api/responses/spoonacular/user_spoonacular/user_spoonacular_request.dart';
import '../../../models/shopping_list/shopping_list.dart';

part 'api_spoonacular_client.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class ApiSpoonacularClient {
  factory ApiSpoonacularClient(Dio dio, {String baseUrl}) =
      _ApiSpoonacularClient;

  @GET(ApiEndpoints.searchRecipes)
  Future<RecipesRandomResponse> searchRecipes(
    @Queries() Map<String, dynamic> queries,
  );

  @GET(ApiEndpoints.getRandomRecipes)
  Future<HttpResponse> getRandomRecipes(
    @Queries() Map<String, dynamic> queries,
  );

  @GET(ApiEndpoints.getInfoRecipe)
  Future<HttpResponse> getInfoRecipe(
    @Path('id') int id,
  );

  @GET(ApiEndpoints.getSimilarRecipes)
  Future<HttpResponse> getSimilarRecipes(
    @Path('id') int id,
  );

  @GET(ApiEndpoints.getIngredient)
  Future<List<Ingredient>?> getIngredient(
    @Query('query') String query,
    @Query('metaInformation') bool metaInformation,
  );

  @POST(ApiEndpoints.analyzeRecipe)
  Future<HttpResponse> getAnalyzeRecipe(
    @Body() RecipeRequest recipeRequest,
  );

  @GET(ApiEndpoints.getNutritionInRecipe)
  Future<Nutrition> getNutritionInRecipe(
    @Path('id') int id,
  );

  @POST(ApiEndpoints.connectUser)
  Future<UserSpoonacularResponse> connectUser(
    @Body() UserSpoonacularRequest request,
  );

  @GET(ApiEndpoints.getMealPlanWeek)
  Future<MealPlanWeek> getMealPlanWeek(
    @Path('username') String username,
    @Path('start-date') String startDate,
    @Query('hash') String hash,
  );

  @GET(ApiEndpoints.getMealPlanDay)
  Future<MealPlanDay> getMealPlanDay(
    @Path('username') String username,
    @Path('date') String date,
    @Query('hash') String hash,
  );

  @POST(ApiEndpoints.addMealPlan)
  Future addMealPlan(@Path('username') String username,
      @Query('hash') String hash, @Body() Map<String, dynamic> mealPlanDay);

  @POST(ApiEndpoints.addMealPlan)
  Future addMealPlans(@Path('username') String username,
      @Query('hash') String hash, @Body() List<RequestMealPlanDay> mealPlanDay);

  @DELETE(ApiEndpoints.getMealPlanDay)
  Future clearMealPlanDay(
    @Path('username') String username,
    @Path('date') String date,
    @Query('hash') String hash,
  );

  @GET(ApiEndpoints.getShoppingList)
  Future<ShoppingList> getShoppingList(
    @Path('username') String username,
    @Query('hash') String hash,
  );

  @POST(ApiEndpoints.addShoppingList)
  Future<ShoppingList> addShoppingList(
    @Path('username') String username,
    @Query('hash') String hash,
    @Body() Map<String, dynamic> request,
  );

  @POST(ApiEndpoints.generateShoppingList)
  Future<ShoppingList> generateShoppingList(
    @Path('username') String username,
    @Query('hash') String hash,
    @Path('start-date') String startDate,
    @Path('end-date') String endDate,
  );

  @DELETE(ApiEndpoints.deleteFromShoppingList)
  Future deleteFromShoppingList(
    @Path('username') String username,
    @Path('id') int id,
    @Query('hash') String hash,
  );

  @DELETE(ApiEndpoints.deleteFromMealPlan)
  Future deleteItemFromMealPlan(
    @Path('username') String username,
    @Path('id') int id,
    @Query('hash') String hash,
  );
}
