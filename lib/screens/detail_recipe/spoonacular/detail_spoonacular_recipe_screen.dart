import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/components/chart/pie_chart.dart';
import 'package:base_code_template_flutter/components/loading/loading_view_model.dart';
import 'package:base_code_template_flutter/components/loading_view_with_animation/shimmer_widget.dart';
import 'package:base_code_template_flutter/data/providers/favourite_recipe_provider.dart';
import 'package:base_code_template_flutter/data/providers/hive_storage_provider.dart';
import 'package:base_code_template_flutter/data/providers/recipe_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/session_repository_provider.dart';
import 'package:base_code_template_flutter/screens/detail_recipe/components/similar_recipe_view.dart';
import 'package:base_code_template_flutter/screens/detail_recipe/detail_recipe_screen.dart';
import 'package:base_code_template_flutter/screens/detail_recipe/detail_recipe_state.dart';
import 'package:base_code_template_flutter/screens/detail_recipe/spoonacular/detail_spoonacular_recipe_view_model.dart';
import 'package:base_code_template_flutter/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../router/app_router.dart';
import '../../../router/detail_recipe_route.dart';

final _provider = StateNotifierProvider.autoDispose<
    DetailSpoonacularRecipeViewModel, DetailSpoonacularRecipeState>(
  (ref) => DetailSpoonacularRecipeViewModel(
    ref: ref,
    spoonacularRepository: ref.watch(recipeSpoonacularRepositoryProvider),
    sessionRepository: ref.watch(sessionRepositoryProvider),
    hiveStorage: ref.watch(hiveStorageProvider),
    favouriteRecipeProvider: ref.read(favouriteRecipeProvider.notifier),
  ),
);

@RoutePage()
class DetailSpoonacularRecipeScreen extends DetailRecipeScreen {
  const DetailSpoonacularRecipeScreen({super.key, required super.recipe});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DetailSpoonacularRecipeViewState();
  }
}

class _DetailSpoonacularRecipeViewState extends DetailRecipeViewState {
  Widget? _chartCaloricBreakdown() {
    final stateNutrition = state.nutrition;
    return stateNutrition != null
        ? PieChart(
            segments: Utilities.convertToListDataChart(
                stateNutrition.caloricBreakdown))
        : ShimmerWidget(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            height: 200,
            width: double.infinity,
          );
  }

  Widget _listSimilarRecipe() {
    final stateSimilarRecipes = state.similarRecipes;
    return stateSimilarRecipes != null
        ? SliverList.builder(
            itemCount: stateSimilarRecipes.length,
            itemBuilder: (context, index) => SimilarRecipeView(
                recipe: stateSimilarRecipes[index],
                onGetInfoRecipe: () {
                  AutoRouter.of(context).push(
                      DetailRecipeRoute(recipe: stateSimilarRecipes[index])
                          .route());
                }))
        : SliverToBoxAdapter(
            child: ShimmerWidget(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            height: 200,
            width: double.infinity,
          ));
  }

  @override
  Future<void> onInitData() async {
    Object? error;
    await loading.whileLoading(context, () async {
      try {
        await viewModel.initData(widget.recipe);
      } catch (e) {
        error = e;
      }
    });

    if (error != null) {
      handleError(error!);
    }
  }

  @override
  DetailSpoonacularRecipeViewModel get viewModel =>
      ref.read(_provider.notifier);

  @override
  String get screenName => DetailSpoonacularRecipeRoute.name;

  @override
  DetailSpoonacularRecipeState get state => ref.watch(_provider);

  @override
  LoadingStateViewModel get loading => ref.watch(loadingStateProvider.notifier);

  @override
  List<Widget> otherSliverView() {
    return <Widget>[
      SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          height: 50,
          child: const Text(
            "Nutrition",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: _chartCaloricBreakdown(),
      ),
      SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          height: 20,
          child: const Text(
            "Similar Recipe",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      _listSimilarRecipe(),
    ];
  }
}
