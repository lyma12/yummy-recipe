import 'package:base_code_template_flutter/data/services/scraping_data/interface_service_scraping.dart';

import '../../models/recipe/recipe.dart';

class ServiceScrapingData {
  final listWebCanScrapeData = [
    "https://www.dienmayxanh.com/vao-bep",
  ];
  Future<List<Recipe>> getRecipeByWeb(String url) async {
    if (url.contains("https://www.dienmayxanh.com/vao-bep")) {
      final webScraping = FactoryScrapingWeb.factory(WebType.dienMayXanh, url);
      final response = await webScraping.getRecipe();
      return response;
    }
    return [];
  }
  Future<bool> canScrape(String url) async {
    for(var link in listWebCanScrapeData){
      if(url.contains(link)){
        return true;
      }
    }
    return false;
  }
}
