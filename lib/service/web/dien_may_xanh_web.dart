import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:html/dom.dart' as dom;

import '../interface_service_scraping_data.dart';

class DienMayXanhWeb extends IServiceScraping {
  DienMayXanhWeb({required super.url});

  static const tagGetImageRecipe = 'div.box-detail > div.video > img';
  static const tagGetServing = 'i.vaobep-people';
  static const tagGetImgIngredient = 'div.perform > p > img';

  static const tagGetNumberRecipeInWeb = 'ul.ready';
  static const tagGetTitleOneRecipe = 'h1';
  static const tagGetSummaryOneRecipe = 'div.leadpost';
  static const tagGetIngredientsOnRecipe =
      'div.box-detail#chuanbi > div.staple > span';
  static const tagGetTimeCookingOnRecipe = 'ul.ready > li > span';
  static const tagGetInstructionOnRecipe = 'div.text-method > p';

  static const tagGetElementRecipeInWeb = 'div.box-recipe';
  static const tagGetTitleMoreRecipe = 'h2';
  static const tagGetSummaryMoreRecipe = 'div.leadpost';
  static const tagGetIngredientsMoreRecipe =
      'div.box-detail > div.staple > span';
  static const tagGetTimeCookingMoreRecipe = 'ul.ready > li > span';
  static const tagGetInstructionMoreRecipe = 'div.text-method > p';

  @override
  Future<List<Recipe>> getRecipe() async {
    dom.Document html = await getWebData();
    final numberOfRecipe =
        html.querySelectorAll(tagGetNumberRecipeInWeb).length;
    if (numberOfRecipe == 1) {
      return aRecipeInWeb(html);
    } else {
      final summary = html.querySelector(tagGetSummaryMoreRecipe)?.text.trim();
      return moreRecipeInWeb(html, summary);
    }
  }

  List<Recipe> aRecipeInWeb(
    dom.Document html,
  ) {
    final title = html.querySelector(tagGetTitleOneRecipe)?.text.trim();
    final summary = html.querySelector(tagGetSummaryOneRecipe)?.text.trim();
    final ingredients = html.querySelectorAll(tagGetIngredientsOnRecipe);
    final minuteCook = html
        .querySelectorAll(tagGetTimeCookingOnRecipe)
        .map((element) => element.innerHtml.trim())
        .toList();
    final imageLink = html.querySelector(tagGetImageRecipe)?.attributes['src'];
    final instruction = html
        .querySelectorAll(tagGetInstructionOnRecipe)
        .map((element) => element.innerHtml.trim())
        .toList();
    final servingString = html.querySelector(tagGetServing)?.text.trim() ?? "1";
    RegExp regExp = RegExp(r'\d+');
    RegExpMatch? match = regExp.firstMatch(servingString);
    int serving = int.parse(match?.group(0) ?? "1");

    final tagImageIngredient = html.querySelector(tagGetImgIngredient);
    final imageIngredient = tagImageIngredient?.attributes['data-src'];
    return [
      Recipe.firebase(
        id: "",
        servings: serving,
        image: imageLink,
        summary: summary,
        readyInMinutes: null,
        cookingMinutes: getCookingMinutes(minuteCook[1]),
        title: title,
        extendedIngredients: getIngredient(ingredients, imageIngredient),
        instructions: getInstruction(instruction),
      ),
    ];
  }

  List<Recipe> moreRecipeInWeb(
    dom.Document html,
    String? summary,
  ) {
    final elementRecipe = html.querySelectorAll(tagGetElementRecipeInWeb);
    List<Recipe> result = [];
    for (var element in elementRecipe) {
      final title = element.querySelector(tagGetTitleMoreRecipe)?.text.trim();
      final ingredients = element.querySelectorAll(tagGetIngredientsMoreRecipe);
      final minuteCook = element
          .querySelectorAll(tagGetTimeCookingMoreRecipe)
          .map((element) => element.innerHtml.trim())
          .toList(growable: false);
      final servingString =
          html.querySelector(tagGetServing)?.text.trim() ?? "1";
      RegExp regExp = RegExp(r'\d+');
      RegExpMatch? match = regExp.firstMatch(servingString);
      int serving = int.parse(match?.group(0) ?? "1");
      final tagImageIngredient = element.querySelector(tagGetImgIngredient);
      final imageIngredient = tagImageIngredient?.attributes['data-src'];
      final instruction = element
          .querySelectorAll(tagGetInstructionMoreRecipe)
          .map((element) => element.innerHtml.trim())
          .toList(growable: false);
      final imageLink =
          element.querySelector(tagGetImageRecipe)?.attributes['data-src'];
      Recipe recipe = Recipe.firebase(
        id: "",
        image: imageLink,
        servings: serving,
        summary: summary,
        readyInMinutes: null,
        cookingMinutes: getCookingMinutes(minuteCook[1]),
        title: title,
        extendedIngredients: getIngredient(ingredients, imageIngredient),
        instructions: getInstruction(instruction),
      );
      result.add(recipe);
    }
    return result;
  }

  String getInstruction(List<String> instruction) {
    return instruction.join("\n");
  }

  List<Ingredient> getIngredient(List<dom.Element> ingredients, String? image) {
    List<Ingredient> results = [];
    int index = 0;
    for (var element in ingredients) {
      final small = element
          .getElementsByTagName('small')
          .map((element) => element.innerHtml.trim())
          .toList();
      final parts = small[0].split(' ');
      final unit = parts[1];
      element.querySelector('small')?.remove();
      final amount = double.tryParse(parts[0]);
      final ingredient = Ingredient(
        id: index++,
        amount: amount,
        image: image,
        unit: unit,
        name: element.text.trim(),
        original: "${small[0]} ${element.text.trim()}",
        possibleUnits: [unit],
      );
      results.add(ingredient);
    }
    return results;
  }

  int getCookingMinutes(String timeString) {
    int totalMinutes = 0;
    final hourRegex = RegExp(r'(\d+)\s*g\w*');
    final minuteRegex = RegExp(r'(\d+)\s*p\w*');
    final hourMatch = hourRegex.firstMatch(timeString);
    if (hourMatch != null) {
      totalMinutes += int.parse(hourMatch.group(1)!) * 60;
    }
    final minuteMatch = minuteRegex.firstMatch(timeString);
    if (minuteMatch != null) {
      totalMinutes += int.parse(minuteMatch.group(1)!);
    }
    return totalMinutes;
  }
}
