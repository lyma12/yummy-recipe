import 'package:base_code_template_flutter/components/base_view/base_view_model.dart';
import 'package:base_code_template_flutter/data/providers/scrape_data_provider.dart';
import 'package:base_code_template_flutter/data/repositories/scraping/scrape_data_repository.dart';
import 'package:base_code_template_flutter/screens/scraping_data/scraping_data_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScrapingDataViewModel extends BaseViewModel<ScrapingDataState> {
  ScrapingDataViewModel({
    required this.ref,
  }) : super(const ScrapingDataState());
  final Ref ref;

  ScrapeDataRepository get scrapingDataRepository =>
      ref.read(scrapeDataRecipeInWebProvider);

  Future changeUrl(String url) async {
    final canScrape = scrapingDataRepository.canScrape(url);
    state = state.copyWith(
      canScraping: canScrape,
      url: url,
    );
  }

  Future scrapeRecipe() async {
    return scrapingDataRepository.getRecipeFromURLWeb(state.url);
  }
}
