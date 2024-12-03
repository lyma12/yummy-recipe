import 'package:base_code_template_flutter/data/repositories/scraping_data/scraping_data_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/scraping_data/service_scraping_data.dart';

final scrapeDataProvider = Provider<ScrapingDataRepository>(
      (ref) => MyScrapingDataTmpl(
    service: ServiceScrapingData(),
  ),
);
