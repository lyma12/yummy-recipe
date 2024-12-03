import 'package:base_code_template_flutter/data/models/api/responses/nutrition/nutrients.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe_request.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipes_random_response.dart';
import 'package:base_code_template_flutter/utilities/constants/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_spoonacular_client.g.dart';

@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class ApiSpoonacularClient {
  factory ApiSpoonacularClient(Dio dio, {String baseUrl}) =
      _ApiSpoonacularClient;

  @GET(ApiEndpoints.searchRecipes)
  Future<RecipesRandomResponse> searchRecipes(
      @Queries() Map<String, dynamic> queries);

  @GET(ApiEndpoints.getRandomRecipes)
  Future<HttpResponse> getRandomRecipes(
      @Queries() Map<String, dynamic> queries);

  @GET(ApiEndpoints.getInfoRecipe)
  Future<HttpResponse> getInfoRecipe(@Path('id') int id);

  @GET(ApiEndpoints.getSimilarRecipes)
  Future<HttpResponse> getSimilarRecipes(@Path('id') int id);

  @GET(ApiEndpoints.getIngredient)
  Future<List<Ingredient>?> getIngredient(@Query('query') String query,
      @Query('metaInformation') bool metaInformation);

  @POST(ApiEndpoints.analyzeRecipe)
  Future<HttpResponse> getAnalyzeRecipe(@Body() RecipeRequest recipeRequest);

  @GET(ApiEndpoints.getNutritionInRecipe)
  Future<Nutrition> getNutritionInRecipe(@Path('id') int id);
}
