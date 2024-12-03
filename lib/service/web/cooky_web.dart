import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:html/dom.dart' as dom;

import '../interface_service_scraping_data.dart';

class CookyWeb extends IServiceScraping {
  CookyWeb({required super.url});

  static const tagGetTitleRecipe = "h3.recipe-name";
  static const tagGetImageRecipe = "img.recipe-cover-photo";
  static const tagGetSummary = "div.recipe-desc-less";
  static const tagGetIngredients = "div.ingredient-list";
  static const tagGetInstruction =
      "div.cook-step-content > div.cook-step-item > div.step-content > p";
  static const tagSpanIngredientName = "span.ingredient-name";
  static const tagSpanIngredientQuantity = "span.ingredient-quantity";
  static const tagSpanServing = "div.recipe-ingredient > span";

  @override
  Future<List<Recipe>> getRecipe() async {
    dom.Document html = await getWebData();
    final titleTag = html.querySelector(tagGetTitleRecipe)?.text.trim();
    final imageTag = html.querySelector(tagGetImageRecipe)?.attributes['src'];
    final listIngredient = html.querySelectorAll(tagGetIngredients);
    final instruction = html
        .querySelectorAll(tagGetInstruction)
        .map((element) => element.text.trim())
        .toList();
    final summary = html.querySelector(tagGetSummary)?.text.trim();
    final servingElement = html.querySelector(tagSpanServing)?.text.trim();
    RegExp regExp = RegExp(r'(\d+)');
    Match? match = regExp.firstMatch(servingElement ?? "");
    int serving = 1;
    if (match != null) {
      serving = int.parse(match.group(1) ?? '1');
    }
    return [
      Recipe.firebase(
        title: titleTag,
        image: imageTag,
        summary: summary,
        servings: serving,
        instructions: getInstruction(instruction),
        extendedIngredients: getIngredient(listIngredient),
        id: "",
      )
    ];
  }

  String getInstruction(List<String> instruction) {
    return instruction.join("\n");
  }

  List<Ingredient> getIngredient(List<dom.Element> ingredients) {
    List<Ingredient> results = [];
    int index = 0;
    RegExp regExp = RegExp(r'(\d+)\s*(\w+)');
    for (var element in ingredients) {
      final nameIngredient =
          element.querySelector(tagSpanIngredientName)?.text.trim();
      final quantityIngredient =
          element.querySelector(tagSpanIngredientQuantity)?.text.trim();
      double count = 0;
      String? unit;
      Match? match = regExp.firstMatch(quantityIngredient ?? "");
      if (match != null) {
        count = double.parse(match.group(1) ?? "0");
        unit = match.group(2);
      }
      final ingredient = Ingredient(
        id: index++,
        unit: unit,
        amount: count,
        name: nameIngredient,
        originalName: "$quantityIngredient $nameIngredient",
        original: "$quantityIngredient $nameIngredient",
        possibleUnits: [unit ?? "part"],
      );
      results.add(ingredient);
    }
    return results;
  }
}
