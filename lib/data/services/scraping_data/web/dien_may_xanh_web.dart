import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/data/services/scraping_data/interface_service_scraping.dart';
import 'package:html/dom.dart' as dom;

class DienMayXanhWeb extends IServiceScraping {
  DienMayXanhWeb({required super.url});

  @override
  Future<List<Recipe>> getRecipe() async {
    dom.Document html = await getWebData();
    final numberOfRecipe = html.querySelectorAll('ul.ready').length;
    if (numberOfRecipe == 1) {
      return aRecipeInWeb(html);
    } else {
      return moreRecipeInWeb(html);
    }
  }

  List<Recipe> aRecipeInWeb(dom.Document html) {
    final title = html.querySelector('h1')?.text.trim();
    final summary = html.querySelector('div.leadpost')?.text.trim();
    final ingredients =
        html.querySelectorAll('div.box-detail#chuanbi > div.staple > span');
    final minuteCook = html
        .querySelectorAll('ul.ready > li > span')
        .map((element) => element.innerHtml.trim())
        .toList();
    final instruction = html
        .querySelectorAll('div.text-method > p')
        .map((element) => element.innerHtml.trim())
        .toList();
    return [
      Recipe.firebase(
        id: "",
        summary: summary,
        cookingMinutes: getCookingMinutes(minuteCook[1]),
        title: title,
        extendedIngredients: getIngredient(ingredients),
        instructions: getInstruction(instruction),
      ),
    ];
  }

  List<Recipe> moreRecipeInWeb(dom.Document html) {
    final elementRecipe = html.querySelectorAll('div.box-recipe');
    List<Recipe> result = [];
    for (var element in elementRecipe) {
      final title = element.querySelector('h2')?.text.trim();
      final summary = element.querySelector('div.leadpost')?.text.trim();
      final ingredients =
          element.querySelectorAll('div.box-detail > div.staple > span');
      final minuteCook = element
          .querySelectorAll('ul.ready > li > span')
          .map((element) => element.innerHtml.trim())
          .toList(growable: false);
      final instruction = element
          .querySelectorAll('div.text-method > p')
          .map((element) => element.innerHtml.trim())
          .toList(growable: false);
      Recipe recipe = Recipe.firebase(
        id: "",
        summary: summary,
        cookingMinutes: getCookingMinutes(minuteCook[1]),
        title: title,
        extendedIngredients: getIngredient(ingredients),
        instructions: getInstruction(instruction),
      );
      result.add(recipe);
    }
    return result;
  }

  String getInstruction(List<String> instruction) {
    return instruction.join("/n");
  }

  List<Ingredient> getIngredient(List<dom.Element> ingredients) {
    List<Ingredient> results = [];
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
        amount: amount,
        unit: unit,
        name: element.text.trim(),
        original: "${small[0]} ${element.text.trim()}",
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
