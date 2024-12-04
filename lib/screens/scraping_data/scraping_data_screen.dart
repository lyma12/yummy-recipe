import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/components/loading/container_with_loading.dart';
import 'package:base_code_template_flutter/components/loading/loading_view_model.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/screens/scraping_data/scraping_data_state.dart';
import 'package:base_code_template_flutter/screens/scraping_data/scraping_data_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/base_view/base_view.dart';
import '../../components/web_components/web_view_container.dart';
import '../../router/app_router.dart';
import '../../utilities/constants/text_constants.dart';

final _provider =
    StateNotifierProvider.autoDispose<ScrapingDataViewModel, ScrapingDataState>(
        (ref) => ScrapingDataViewModel(
              ref: ref,
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
              child:
                  Text(AppLocalizations.of(context)?.scrape ?? "Scrape data"),
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
          await viewModel.scrapeRecipe().then((listRecipe) async {
            if (mounted) {
              await showRecipeDialog(context, listRecipe);
            }
          });
        } catch (e) {
          await handleError(e);
        }
      },
    );
  }

  Future _showScrapeData(Recipe recipe) async {
    await AutoRouter.of(context).replace(CreateRoute(recipe: recipe));
  }

  Future showRecipeDialog(BuildContext context, List<Recipe> recipes) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)?.recipes ?? 'Recipe List'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return ListTile(
                  leading: CachedNetworkImage(
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    imageUrl: recipe.image ?? "",
                  ),
                  title: Text(recipe.title ?? ""),
                  subtitle: Text(
                    recipe.summary ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _showScrapeData(recipe);
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(AppLocalizations.of(context)?.close ?? 'Close'),
            ),
          ],
        );
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
