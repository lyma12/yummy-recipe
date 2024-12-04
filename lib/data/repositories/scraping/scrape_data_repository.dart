import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/service/interface_service_scraping_data.dart';

abstract class ScrapeDataRepository {
  Future getRecipeFromURLWeb(String url);

  bool canScrape(String url);
}

class ScapeDataRepositoryImpl implements ScrapeDataRepository {
  static const List<String> linkWeb = [
    "https://www.dienmayxanh.com/vao-bep",
    "https://www.cooky.vn/cong-thuc",
    "https://www.disneycooking.com"
  ];
  static const List<WebType> webType = [
    WebType.dienMayXanh,
    WebType.cooky,
    WebType.disneyCooking,
  ];

  @override
  Future<List<Recipe>> getRecipeFromURLWeb(String url) async {
    final indexUrlInList = getIndexUrlInList(url);
    if (indexUrlInList == -1) throw Exception("Error scraping data in $url");
    return await FactoryScrapingWeb.factory(webType[indexUrlInList], url)
        .getRecipe();
  }

  int getIndexUrlInList(String url) {
    for (int i = 0; i < linkWeb.length; i++) {
      if (url.contains(linkWeb[i])) {
        return i;
      }
    }
    return -1;
  }

  @override
  bool canScrape(String url) {
    final indexWebInLink = getIndexUrlInList(url);
    return indexWebInLink != -1;
  }
}
