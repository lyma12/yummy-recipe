class ApiEndpoints {
  // spoonacular
  static const String baseUrl = 'https://api.spoonacular.com/';
  static const String searchRecipes = '/recipes/complexSearch';
  static const String getRandomRecipes = '/recipes/random';
  static const String getInfoRecipe = '/recipes/{id}/information';
  static const String getSimilarRecipes = '/recipes/{id}/similar';
  static const String getIngredient = '/food/ingredients/autocomplete';
  static const String analyzeRecipe = '/recipes/analyze';
  static const String getNutritionInRecipe =
      '/recipes/{id}/nutritionWidget.json';
  static const String connectUser = '/users/connect';

  static const String getMealPlanWeek =
      '/mealplanner/{username}/week/{start-date}';
  static const String getMealPlanDay = '/mealplanner/{username}/day/{date}';
  static const String addMealPlan = '/mealplanner/{username}/items';
  static const String getShoppingList = '/mealplanner/{username}/shopping-list';
  static const String addShoppingList =
      '/mealplanner/{username}/shopping-list/items';
  static const String generateShoppingList = '$getShoppingList/{start-date}/{end-date}';
  static const String deleteFromShoppingList = '$addShoppingList/{id}';
  static const String deleteFromMealPlan = '$addMealPlan/{id}';
}
