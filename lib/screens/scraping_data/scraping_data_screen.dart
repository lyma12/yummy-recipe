import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/components/dialog/dialog_provider.dart';
import 'package:base_code_template_flutter/components/dialog/scrape_data_dialog.dart';
import 'package:base_code_template_flutter/components/loading/container_with_loading.dart';
import 'package:base_code_template_flutter/components/loading/loading_view_model.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/data/providers/scrape_data_provider.dart';
import 'package:base_code_template_flutter/router/app_router.dart';
import 'package:base_code_template_flutter/screens/scraping_data/scraping_data_state.dart';
import 'package:base_code_template_flutter/screens/scraping_data/scraping_data_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/base_view/base_view.dart';
import '../../components/web_components/web_view_container.dart';
import '../../utilities/constants/text_constants.dart';

final _provider =
    StateNotifierProvider.autoDispose<ScrapingDataViewModel, ScrapingDataState>(
        (ref) => ScrapingDataViewModel(
              ref: ref,
              scrapingDataRepository: ref.read(scrapeDataProvider),
            ));

@RoutePage()
class ScrapingDataScreen extends BaseView {
  const ScrapingDataScreen({
    super.key,
    this.onSelectRecipe,
  });

  final Function(Recipe)? onSelectRecipe;

  @override
  BaseViewState<ScrapingDataScreen, ScrapingDataViewModel> createState() =>
      _ScrapingDataViewState();
}

class _ScrapingDataViewState
    extends BaseViewState<ScrapingDataScreen, ScrapingDataViewModel> {
  late Function(Recipe) onSelect;

  @override
  void onInitState() {
    super.onInitState();
    onSelect = widget.onSelectRecipe ?? (_) {};
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return ContainerWithLoading(
      child: Column(
        children: [
          Expanded(
            child: WebViewContainer(
              uri: TextConstants.webViewGoogle,
              onUrlChanged: (value) {
                viewModel.changeUrl(value);
              },
            ),
          ),
          if (state.canScraping)
            ElevatedButton(
              onPressed: () async {
                await _scrapeDate();
              },
              child: const Text("Scrape data"),
            ),
        ],
      ),
    );
  }

  Future _scrapeDate() async {
    loading.whileLoading(
      context,
      () async {
        try {
          await viewModel.scrapeDataRecipe().then(
            (value) {
              if (mounted) {
                ref.read(alertDialogProvider).showAlertDialog(
                    context: context,
                    dialog: ScrapeDataDialog(
                        onSelect: (value) {
                          onSelect(value);
                        },
                        listRecipe: value),
                    barrierDismissible: true);
              }
            },
          );
        } catch (e) {
          await handleError(e);
        }
      },
    );
  }

  LoadingStateViewModel get loading => ref.watch(loadingStateProvider.notifier);

  @override
  String get screenName => ScrapingDataRoute.name;

  ScrapingDataState get state => ref.watch(_provider);

  @override
  ScrapingDataViewModel get viewModel => ref.read(_provider.notifier);
}
