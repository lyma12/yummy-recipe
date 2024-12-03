import 'package:base_code_template_flutter/components/base_view/base_view.dart';
import 'package:base_code_template_flutter/components/loading_view_with_animation/shimmer_widget.dart';
import 'package:base_code_template_flutter/components/web_components/html_widget.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:base_code_template_flutter/resources/gen/colors.gen.dart';
import 'package:base_code_template_flutter/screens/detail_recipe/components/recipe_icon_view.dart';
import 'package:base_code_template_flutter/screens/detail_recipe/detail_recipe_state.dart';
import 'package:base_code_template_flutter/screens/detail_recipe/detail_recipe_view_model.dart';
import 'package:base_code_template_flutter/utilities/exceptions/extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/models/recipe/recipe.dart';

abstract class DetailRecipeScreen extends BaseView {
  const DetailRecipeScreen({super.key, required this.recipe});

  final Recipe recipe;
}

abstract class DetailRecipeViewState
    extends BaseViewState<DetailRecipeScreen, DetailRecipeViewModel> {
  @override
  Future<bool> onWillPop() {
    viewModel.returnRecipeBefore();
    return super.onWillPop();
  }

  @override
  Future<void> onInitState() async {
    super.onInitState();
    await Future.delayed(Duration.zero, () async {
      await onInitData();
    });
  }

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
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(
        title:
            state.recipe != null ? Text(state.recipe?.title ?? "Recipe") : null,
        actions: [
          IconButton(
              onPressed: () async {
                if (state.recipe != null) {
                  await viewModel.saveRecipeInLocalStorage(state.recipe!);
                }
              },
              icon: Icon(
                Icons.download,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
      );

  @override
  Widget buildBody(BuildContext context) {
    return ContainerWithLoading(
        child: CustomScrollView(
      slivers: [
        ...recipeView(),
        ...otherSliverView(),
      ],
    ));
  }

  List<Widget> otherSliverView();

  List<Widget> recipeView() {
    return <Widget>[
      _topViewDetail(),
      SliverToBoxAdapter(
        child: _remarkRecipe(),
      ),
      SliverToBoxAdapter(
        child: _summaryRecipe(),
      ),
      SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          height: 50,
          child: const Text(
            "Ingredients",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      _listIngredients(),
      SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          height: 20,
          child: const Text(
            "Instruction",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: _instructions(),
      ),
    ];
  }

  Widget _getListTags() {
    final tags = Utilities.getTagsRecipe(state.recipe);
    return state.recipe != null
        ? SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: tags.length,
              itemBuilder: (context, index) {
                return RecipeIconview(type: tags[index]);
              },
            ),
          )
        : ShimmerWidget(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            height: 240,
            width: 40,
          );
  }

  Widget _topViewDetail() {
    return SliverToBoxAdapter(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: Hero(
                tag: 'image_transition_detail_recipe',
                child: state.recipe?.image != null
                    ? CachedNetworkImage(
                        imageUrl: state.recipe?.image ?? "",
                        fit: BoxFit.cover,
                        width: 200,
                        height: 220,
                      )
                    : const ShimmerWidget(height: 200, width: 220),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              child: _getListTags(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listIngredients() {
    return state.recipe != null
        ? SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250.0,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 5.0,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill,
                          imageUrl:
                              "https://img.spoonacular.com/ingredients_100x100/${state.recipe?.extendedIngredients[index].image}",
                        ),
                        Text(
                          state.recipe?.extendedIngredients[index].original ??
                              "",
                          overflow: TextOverflow.clip,
                        ),
                      ],
                    ));
              },
              childCount: state.recipe?.extendedIngredients.length,
            ),
          )
        : SliverToBoxAdapter(
            child: ShimmerWidget(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            height: 200,
            width: double.infinity,
          ));
  }

  Widget _instructions() {
    return state.recipe != null
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.all(10),
            color: ColorName.orange33EE6723,
            child: Text(
              viewModel.prepareInstruction(state.recipe?.instructions ?? ""),
            ),
          )
        : ShimmerWidget(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            height: 200,
            width: double.infinity,
          );
  }

  Widget _remarkRecipe() {
    final stateRecipe = state.recipe;
    return stateRecipe != null
        ? Column(
            children: [
              Text(
                stateRecipe.dishTypes.join(', '),
                style: AppTextStyles.bodyMediumItalic.copyWith(
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Tooltip(
                    message: AppLocalizations.of(context)?.spoonacular_score,
                    child: const Icon(
                      size: 20,
                      Icons.star,
                      color: Colors.yellow,
                    ),
                  ),
                  Text(
                    (state.recipe?.spoonacularScore ?? 0).toStringAsFixed(1),
                    style: AppTextStyles.titleSmall.copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Tooltip(
                    message: AppLocalizations.of(context)?.health_score,
                    child: const Icon(
                      Icons.health_and_safety_outlined,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    (state.recipe?.healthScore ?? 0).toStringAsFixed(1),
                    style: AppTextStyles.titleSmall.copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Tooltip(
                    message: AppLocalizations.of(context)?.ready_in_minutes,
                    child: const Icon(
                      size: 20,
                      Icons.timer_sharp,
                      color: Colors.yellow,
                    ),
                  ),
                  Text(
                    "${stateRecipe.readyInMinutes?.toStringAsFixed(1)}s",
                    style: AppTextStyles.titleSmall.copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Tooltip(
                    message: AppLocalizations.of(context)?.cost_serving,
                    child: const Icon(
                      size: 20,
                      Icons.price_check_sharp,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    "\$${stateRecipe.pricePerServing?.toStringAsFixed(1)}",
                    style: AppTextStyles.titleSmall.copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          )
        : ShimmerWidget(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            height: 50,
            width: double.infinity,
          );
  }

  Widget _summaryRecipe() {
    return state.recipe != null
        ? Container(
            margin: const EdgeInsets.all(20),
            child: HtmlWidget(
              htmlData: state.recipe?.summary ?? "",
            ),
          )
        : ShimmerWidget(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            height: 200,
            width: double.infinity,
          );
  }

  DetailRecipeState get state;

  LoadingStateViewModel get loading => ref.read(loadingStateProvider.notifier);

}
