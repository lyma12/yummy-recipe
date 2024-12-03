import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:html/dom.dart' as dom;

import '../../data/models/api/responses/spooncular/recipe.dart';
import '../interface_service_scraping_data.dart';

class DisneyCooking extends IServiceScraping {
  DisneyCooking({required super.url});

  static const tagGetTitle = 'h1.post-title';
  static const tagGetImage = 'div.post-content.description > p > img';
  static const tagGetSummary = 'div.post-content.description > p';
  static const tagGetIngredients = 'div.post-content.description > ul';
  static const tagGetIngredientsTitle =
      'div.post-content.description > h3 > span#Nguyen_lieu';
  static const tagGetInstruction = 'div.post-container.cf > div > div > p';

  @override
  Future<List<Recipe>> getRecipe() async {
    dom.Document html = await getWebData();
    final title = html.querySelector(tagGetTitle)?.text.trim();
    final image = html.querySelector(tagGetImage);
    final summary = html
        .querySelectorAll(tagGetSummary)
        .map((element) => element.innerHtml)
        .toList()
        .join("\n");
    final ingredientH3 = html.querySelector(tagGetIngredientsTitle)?.parent;
    final ingredients = ingredientH3?.nextElementSibling
            ?.querySelectorAll('li')
            .map((element) => element.innerHtml)
            .toList() ??
        [];
    final instruction = html
        .querySelectorAll(tagGetInstruction)
        .map((element) => element.innerHtml)
        .toList();
    return [
      Recipe.firebase(
        id: "",
        title: title,
        image: image?.attributes['src'],
        summary: summary,
        instructions: getInstruction(instruction),
        extendedIngredients: getIngredient(ingredients),
      ),
    ];
  }

  String getInstruction(List<String> instruction) {
    return instruction.join("\n");
  }

  List<Ingredient> getIngredient(List<String> ingredients) {
    List<Ingredient> results = [];
    int index = 0;
    RegExp regExp = RegExp(r"(\d+)([a-zA-Z]+)\s*(.*)");
    for (var element in ingredients) {
      double count = 0;
      String? unit;
      String? name;
      Match? match = regExp.firstMatch(element);
      if (match != null) {
        count = double.parse(match.group(1) ?? "0");
        unit = match.group(2);
        name = match.group(3);
      }
      final ingredient = Ingredient(
        id: index++,
        unit: unit,
        amount: count,
        name: name,
        originalName: element,
        original: element,
        possibleUnits: [unit ?? "part"],
      );
      results.add(ingredient);
    }
    return results;
  }
}
