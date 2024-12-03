class SpoonacularException implements Exception {
  final String message;
  final int code;

  SpoonacularException({required this.message, this.code = 0});

  @override
  String toString() => 'SpoonacularException: $message (Code: $code)';
}

class SpoonacularConnectException extends SpoonacularException {
  SpoonacularConnectException(
      {super.message = 'Unable to connect to Spoonacular API', super.code = 1});
}

class SpoonacularNoMealPlanDay extends SpoonacularException {
  SpoonacularNoMealPlanDay(
      {super.message = 'No meals planned for that day', super.code = 2});
}

class SpoonacularNoMealPlanWeek extends SpoonacularException {
  SpoonacularNoMealPlanWeek(
      {super.message = 'No meals planned for that week', super.code = 2});
}

class SpoonacularNoShoppingList extends SpoonacularException {
  SpoonacularNoShoppingList(
      {super.message = 'No items in shopping list', super.code = 2});
}
