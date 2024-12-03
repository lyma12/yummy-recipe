import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/data/services/scraping_data/web/dien_may_xanh_web.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

abstract class IServiceScraping {
  IServiceScraping({
    required String url,
  }) : _url = url;
  final String _url;

  Future<dom.Document> getWebData() async {
    final url = Uri.parse(_url);
    final response = await http.get(url);
    return dom.Document.html(response.body);
  }

  Future<List<Recipe>> getRecipe();
}

class FactoryScrapingWeb {
  FactoryScrapingWeb._();

  static IServiceScraping factory(WebType type, String url) {
    switch (type) {
      case WebType.dienMayXanh:
        return DienMayXanhWeb(url: url);
    }
  }
}

enum WebType {
  dienMayXanh,
}
