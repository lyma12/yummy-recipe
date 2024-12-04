import 'package:base_code_template_flutter/utilities/constants/text_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scraping_data_state.freezed.dart';

@freezed
class ScrapingDataState with _$ScrapingDataState {
  const factory ScrapingDataState({
    @Default(false) bool canScraping,
    @Default(TextConstants.webViewGoogle) url,
  }) = _ScrapingDataState;

  const ScrapingDataState._();
}
