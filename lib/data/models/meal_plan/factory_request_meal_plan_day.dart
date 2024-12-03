import 'package:base_code_template_flutter/data/models/meal_plan/meal_plan.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/utilities/constants/app_constants.dart';

class FactoryRequestMealPlanDay {
  FactoryRequestMealPlanDay._();

  static ProductRequestMealPlanDay factory(
      Recipe recipe, DateTime dateTime, int slot) {
    switch (recipe) {
      case FirebaseRecipe():
        return ProductIngredientsRequestMealPlanDay(
            recipe: recipe, date: dateTime, slot: slot);
      case SpooncularRecipe():
        return ProductRecipeRequestMealPlanDay(
            recipe: recipe, date: dateTime, slot: slot);
    }
  }
}

abstract class ProductRequestMealPlanDay {
  ProductRequestMealPlanDay({
    required Recipe recipe,
    required DateTime date,
    required int slot,
    required String type,
  })  : _slot = slot,
        _type = type,
        _date = date,
        _recipe = recipe;

  final Recipe _recipe;
  final DateTime _date;
  final String _type;
  final int _slot;

  int _getDateInt() {
    var result =
        _date.copyWith(year: _date.year, month: _date.month, day: _date.day);
    return result.microsecondsSinceEpoch ~/ 1000000 + 25200;
  }

  RequestMealPlanDay getRequestMealPlanDay() {
    return RequestMealPlanDay(
      date: _getDateInt(),
      slot: _slot,
      position: 0,
      type: _type,
      value: _getItemMealValue(),
    );
  }

  ItemMealValue _getItemMealValue();
}

class ProductIngredientsRequestMealPlanDay extends ProductRequestMealPlanDay {
  ProductIngredientsRequestMealPlanDay({
    required super.recipe,
    required super.date,
    required super.slot,
    super.type = AppConstants.itemMealPlanTypeIngredients,
  });

  @override
  ItemMealValue _getItemMealValue() {
    return ItemMealValue(
      servings: _recipe.servings.toString(),
      image: _recipe.image,
      id: _recipe.id.toString(),
      title: _recipe.title,
      ingredients: _getIngredient(),
    );
  }

  List<Map<String, dynamic>> _getIngredient() {
    List<Map<String, dynamic>> result = [];
    for (var item in _recipe.extendedIngredients) {
      result.add({
        "name": item.original ?? "${item.amount} ${item.unit} ${item.name}"
      });
    }
    return result;
  }
}

class ProductRecipeRequestMealPlanDay extends ProductRequestMealPlanDay {
  ProductRecipeRequestMealPlanDay(
      {required super.recipe,
      required super.date,
      required super.slot,
      super.type = AppConstants.itemMealPlanTypeRecipe});

  @override
  ItemMealValue _getItemMealValue() {
    return ItemMealValue(
      servings: _recipe.servings.toString(),
      image: _recipe.image,
      id: _recipe.id.toString(),
      title: _recipe.title,
    );
  }
}
