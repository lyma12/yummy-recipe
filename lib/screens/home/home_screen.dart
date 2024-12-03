import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/components/divider/divider_horizontal.dart';
import 'package:base_code_template_flutter/components/loading/container_with_loading.dart';
import 'package:base_code_template_flutter/components/loading/loading_view_model.dart';
import 'package:base_code_template_flutter/data/providers/auth_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/hive_storage_provider.dart';
import 'package:base_code_template_flutter/data/providers/recipe_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/session_repository_provider.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:base_code_template_flutter/resources/gen/assets.gen.dart';
import 'package:base_code_template_flutter/screens/home/components/item_recipe_view.dart';
import 'package:base_code_template_flutter/screens/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../components/base_view/base_view.dart';
import '../../router/app_router.dart';
import '../../router/detail_recipe_route.dart';
import 'components/item_firebase_recipe_view.dart';
import 'home_view_model.dart';

final _provider = StateNotifierProvider.autoDispose<HomeViewModel, HomeState>(
  (ref) => HomeViewModel(
    firebaseStoreResposity: ref.watch(recipeFirebaseRepositoryProvider),
    auth: ref.read(firebaseAuthRepositoryProvider),
    ref: ref,
    sessionRepository: ref.watch(sessionRepositoryProvider),
    spoonacularRepository: ref.watch(recipeSpoonacularRepositoryProvider),
    hiveStorage: ref.watch(hiveStorageProvider),
  ),
);

/// Screen code: A_05
@RoutePage()
class HomeScreen extends BaseView {
  const HomeScreen({super.key});

  @override
  BaseViewState<HomeScreen, HomeViewModel> createState() => _HomeViewState();
}

class _HomeViewState extends BaseViewState<HomeScreen, HomeViewModel> {
  ScrollController scrollControllerListSpoonacular = ScrollController();
  ScrollController scrollControllerListFirebase = ScrollController();

  @override
  Future<void> onInitState() async {
    super.onInitState();
    await Future.delayed(Duration.zero, () async {
      await _onInitData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollControllerListSpoonacular.removeListener(_scrollListener);
    scrollControllerListSpoonacular.removeListener(_scrollCustomScrollView);
  }

  Future<void> _onInitData() async {
    Object? error;
    scrollControllerListSpoonacular = ScrollController()
      ..addListener(_scrollListener);
    scrollControllerListFirebase = ScrollController()
      ..addListener(_scrollCustomScrollView);
    await loading.whileLoading(context, () async {
      try {
        await viewModel.initData();
      } catch (e) {
        error = e;
      }
    });

    if (error != null) {
      handleError(error!);
    }
  }

  Future<void> _scrollListener() async {
    if (scrollControllerListSpoonacular.position.extentAfter < 3) {
      await viewModel.getMoreRecipe();
    }
  }

  void _scrollCustomScrollView() {
    if (scrollControllerListFirebase.position.extentAfter < 4) {
      viewModel.loadMoreRecipes();
    }
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return ContainerWithLoading(
      child: CustomScrollView(
        controller: scrollControllerListFirebase,
        slivers: [
          SliverToBoxAdapter(
            child: _topBanner(context),
          ),
          SliverToBoxAdapter(
            child: _buildRecipeListData(),
          ),
          _buildListRecipePost(),
        ],
      ),
    );
  }

  Widget _topBanner(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: Assets.images.signinBackGround.provider(),
            fit: BoxFit.cover),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: double.infinity,
              height: 120,
            ),
            const Row(
              children: [
                Icon(
                  Icons.add_location_alt_outlined,
                  color: Colors.white,
                ),
                Text(
                  "location",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            Text(
              viewModel.getMessage(AppLocalizations.of(context)) ?? "",
              style: AppTextStyles.bodyLargeWhite,
            ),
            Text(
              viewModel.getMessageSuggest(AppLocalizations.of(context)) ?? "",
              style: AppTextStyles.bodyLargeWhite,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeListData() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              AppLocalizations.of(context)?.recipes ?? "Recipes",
              style: AppTextStyles.titleLarge,
            ),
            IconButton(
                onPressed: () {
                  viewModel.getMoreRecipe();
                },
                icon: const Icon(Icons.keyboard_arrow_right_sharp)),
          ],
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 4.0,
            ),
            controller: scrollControllerListSpoonacular,
            scrollDirection: Axis.horizontal,
            itemCount: state.recipeList.length,
            itemBuilder: (context, index) {
              final recipe = state.recipeList[index];
              return ItemRecipeView(
                recipe: recipe,
                onGetInfoRecipe: () {
                  AutoRouter.of(context)
                      .push(DetailRecipeRoute(recipe: recipe).route());
                },
              );
            },
          ),
        ),
        const DividerHorizontal(height: 5),
      ],
    );
  }

  Widget _buildListRecipePost() {
    final recipesPost = state.recipePostList;
    return SliverList.builder(
      itemBuilder: (context, index) {
        final recipe = recipesPost?[index];
        return ItemFirebaseRecipeView(
          recipe: recipe,
          onSeeMore: () {
            if (recipe != null) {
              AutoRouter.of(context)
                  .push(DetailRecipeRoute(recipe: recipe).route());
            }
          },
          onCommentTap: () {
            if (recipe != null) {
              AutoRouter.of(context)
                  .push(DetailRecipeRoute(recipe: recipe).route());
            }
          },
          onLikeTap: () async {
            if (recipe != null) {
              await viewModel.like(recipe);
            }
          },
          isHasLike: recipe != null ? viewModel.isHasLike(recipe) : false,
        );
      },
      itemCount: recipesPost?.length ?? 0,
    );
  }

  @override
  HomeViewModel get viewModel => ref.read(_provider.notifier);

  @override
  String get screenName => HomeRoute.name;

  HomeState get state => ref.watch(_provider);

  LoadingStateViewModel get loading => ref.read(loadingStateProvider.notifier);
}
