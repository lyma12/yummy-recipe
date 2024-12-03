import 'package:base_code_template_flutter/components/base_view/base_view_model.dart';
import 'package:base_code_template_flutter/data/repositories/scraping_data/scraping_data_repository.dart';
import 'package:base_code_template_flutter/screens/scraping_data/scraping_data_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/recipe/recipe.dart';

class ScrapingDataViewModel extends BaseViewModel<ScrapingDataState>{
  ScrapingDataViewModel({
    required this.ref,
    required this.scrapingDataRepository,
}) : super(const ScrapingDataState());
  final Ref ref;
  final ScrapingDataRepository scrapingDataRepository;
  Future changeUrl(String url) async {
    final canScrape = await scrapingDataRepository.canScrapeData(url);
    state = state.copyWith(
      url: url,
      canScraping: canScrape,
    );
  }
  Future<List<Recipe>> scrapeDataRecipe() async {
    return await scrapingDataRepository.scrapeData(state.url);
  }
}