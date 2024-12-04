import 'package:base_code_template_flutter/data/repositories/scraping/scrape_data_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scrapeDataRecipeInWebProvider = Provider<ScrapeDataRepository>(
  (ref) => ScapeDataRepositoryImpl(),
);
