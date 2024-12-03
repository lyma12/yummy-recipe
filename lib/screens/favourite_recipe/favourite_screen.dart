import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/components/dialog/create_meal_plan_dialog.dart';
import 'package:base_code_template_flutter/components/dialog/dialog_provider.dart';
import 'package:base_code_template_flutter/components/divider/divider_horizontal.dart';
import 'package:base_code_template_flutter/components/loading/loading_view_model.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/data/providers/auth_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/favourite_recipe_provider.dart';
import 'package:base_code_template_flutter/data/providers/hive_storage_provider.dart';
import 'package:base_code_template_flutter/data/providers/recipe_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/secure_storage_provider.dart';
import 'package:base_code_template_flutter/data/providers/user_provider.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:base_code_template_flutter/screens/favourite_recipe/components/item_favourite.dart';
import 'package:base_code_template_flutter/screens/favourite_recipe/favourite_state.dart';
import 'package:base_code_template_flutter/utilities/utilities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../components/base_view/base_view.dart';
import '../../components/richtext/app_rich_text.dart';
import '../../resources/gen/assets.gen.dart';
import '../../router/app_router.dart';
import '../../router/detail_recipe_route.dart';
import 'favourite_view_model.dart';

final _provider =
    StateNotifierProvider.autoDispose<FavouriteViewModel, FavouriteState>(
  (ref) => FavouriteViewModel(
    hiveStorage: ref.read(hiveStorageProvider),
    favouriteRecipeNotifier: ref.read(favouriteRecipeProvider.notifier),
    ref: ref,
    spoonacularRepository: ref.read(recipeSpoonacularRepositoryProvider),
    firebaseAuth: ref.read(firebaseAuthRepositoryProvider),
    secureStorageManager: ref.read(secureStorageProvider),
    userFirebaseRepository: ref.read(userProfileProvider),
  ),
);

/// Screen code: A_06
@RoutePage()
class FavouriteScreen extends BaseView {
  const FavouriteScreen({super.key});

  @override
  BaseViewState<FavouriteScreen, FavouriteViewModel> createState() =>
      _FavouriteViewState();
}

class _FavouriteViewState
    extends BaseViewState<FavouriteScreen, FavouriteViewModel> {
  final PageController _controller = PageController(
    viewportFraction: 0.7,
  );
  int _indexFavouritePage = 0;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await viewModel.initData();
  }

  void gotoDetailRecipe(Recipe recipe) {
    AutoRouter.of(context).push(
      DetailRecipeRoute(recipe: recipe).route(),
    );
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _topCell(AppLocalizations.of(context)?.favourite_recipes ??
            "Favourite recipes"),
        _listFavouriteRecipe(),
        _topCell(AppLocalizations.of(context)?.save_recipes ?? "Save recipes"),
        _listSaveRecipe(),
      ],
    );
  }

  Widget _topCell(String name) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              name,
              style: AppTextStyles.titleMediumBold,
            ),
          ),
          const DividerHorizontal(),
        ],
      ),
    );
  }

  Widget _listFavouriteRecipe() {
    final favouriteRecipes = state.favouriteRecipes;
    final hasData = favouriteRecipes.isNotEmpty;
    return SliverAppBar(
      elevation: 0,
      expandedHeight: 300,
      pinned: hasData,
      toolbarHeight: hasData ? 300 : 0,
      flexibleSpace: favouriteRecipes.isNotEmpty
          ? SizedBox(
              height: 320,
              child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: favouriteRecipes.length,
                  onPageChanged: (index) =>
                      setState(() => _indexFavouritePage = index),
                  controller: _controller,
                  itemBuilder: (context, index) {
                    final recipe = favouriteRecipes[index];
                    final isSelected = index == _indexFavouritePage;
                    return Center(
                      child: Transform.scale(
                        scale: isSelected ? 1.2 : 1,
                        child: ItemFavourite(
                          recipe: recipe,
                          onTap: () {
                            gotoDetailRecipe(recipe);
                          },
                        ),
                      ),
                    );
                  }),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                AppLocalizations.of(context)?.no_favourite_recipe ??
                    "Have no favourite recipes",
                style: AppTextStyles.bodyMediumItalic,
              ),
            ),
    );
  }

  Widget _listSaveRecipe() {
    return listRecipeFavourite.isNotEmpty
        ? SliverList.separated(
            separatorBuilder: (context, index) => const DividerHorizontal(),
            itemCount: listRecipeFavourite.length,
            itemBuilder: (context, index) {
              final recipe = listRecipeFavourite[index];
              return Dismissible(
                key: Key((listRecipeFavourite[index].id).toString()),
                onDismissed: (value) {
                  // remove favourite
                },
                child: ListTile(
                  leading: CachedNetworkImage(
                    width: 120,
                    height: 500,
                    imageUrl: recipe.image ?? "",
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Assets
                        .images.signinBackGround
                        .image(fit: BoxFit.cover, width: 120, height: 500),
                  ),
                  title: Text(
                    recipe.title ?? "",
                    style: AppTextStyles.titleMediumBold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utilities.formatDateTime(
                            recipe.timeStamp ?? DateTime.now()),
                        style: AppTextStyles.bodySmall,
                      ),
                      AppRichText.richTextIconText(
                        data: recipe.servings.toString(),
                        name: AppLocalizations.of(context)?.serving,
                        icon: const Icon(
                          Icons.person,
                          size: 12,
                        ),
                      ),
                      AppRichText.richTextIconText(
                        data: (recipe.spoonacularScore ?? 0)
                            .roundToDouble()
                            .toString(),
                        name: AppLocalizations.of(context)?.spoonacular_score,
                        icon: const Icon(
                          Icons.star,
                          size: 12,
                        ),
                      )
                    ],
                  ),
                  trailing: IconButton(
                      onPressed: () async {
                        await showCreateMealPlanDialog(recipe);
                      },
                      icon: const Icon(Icons.add)),
                  onTap: () => gotoDetailRecipe(recipe),
                ),
              );
            },
          )
        : SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppLocalizations.of(context)?.no_save_recipe ??
                    "Have no save recipes",
                style: AppTextStyles.bodyMediumItalic,
              ),
            ),
          );
  }

  Future showCreateMealPlanDialog(Recipe recipe) async {
    await ref.read(alertDialogProvider).showAlertDialog(
          context: context,
          dialog: CreateMealPlanDialog(
            onSubmit: (date, timeOfDay) async {
              await _addToMealPlan(date, timeOfDay, recipe);
            },
            nameRecipe: recipe.title ?? "no name",
          ),
          barrierDismissible: true,
        );
  }

  Future<void> _addToMealPlan(
      DateTime date, int timeOfDay, Recipe recipe) async {
    Object? error;
    await loading.whileLoading(
      context,
      () async {
        try {
          await viewModel.addMealPlanDay(date, timeOfDay, recipe).then(
            (_) {
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
          );
        } catch (e) {
          error = e;
        }
      },
    );

    if (error != null) {
      handleError(error!);
    }
  }

  LoadingStateViewModel get loading => ref.read(loadingStateProvider.notifier);

  FavouriteState get state => ref.watch(_provider);

  @override
  FavouriteViewModel get viewModel => ref.read(_provider.notifier);

  List<Recipe> get listRecipeFavourite => ref.watch(favouriteRecipeProvider);

  @override
  String get screenName => FavouriteRoute.name;
}
