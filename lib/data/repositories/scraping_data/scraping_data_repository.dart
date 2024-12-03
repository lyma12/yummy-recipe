import 'package:base_code_template_flutter/data/services/scraping_data/service_scraping_data.dart';

abstract class ScrapingDataRepository {
  Future<bool> canScrapeData(String url);
  Future scrapeData(String url);
}
class MyScrapingDataTmpl implements ScrapingDataRepository{
  const MyScrapingDataTmpl({required this.service});
  final ServiceScrapingData service;
  @override
  Future<bool> canScrapeData(String url) async {
    return await service.canScrape(url);
  }
  @override
  Future scrapeData(String url) async {
    return await service.getRecipeByWeb(url);
  }

}