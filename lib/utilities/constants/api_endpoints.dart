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
}
