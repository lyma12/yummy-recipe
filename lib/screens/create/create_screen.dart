import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/components/app_bar/create_app_bar.dart';
import 'package:base_code_template_flutter/components/base_view/base_view.dart';
import 'package:base_code_template_flutter/components/file_picker/image_form_gallery_ex.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe.dart';
import 'package:base_code_template_flutter/data/providers/auth_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/firebase_store_provider.dart';
import 'package:base_code_template_flutter/data/providers/recipe_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/session_repository_provider.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:base_code_template_flutter/resources/gen/colors.gen.dart';
import 'package:base_code_template_flutter/router/app_router.dart';
import 'package:base_code_template_flutter/screens/create/component/ingredient_create_view.dart';
import 'package:base_code_template_flutter/screens/create/component/result_analyze_recipe.dart';
import 'package:base_code_template_flutter/screens/create/create_state.dart';
import 'package:base_code_template_flutter/screens/create/create_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider =
    StateNotifierProvider.autoDispose<CreateViewModel, CreateState>(
  (ref) => CreateViewModel(
    ref: ref,
    spoonacularRepository: ref.read(recipeSpoonacularRepositoryProvider),
    sessionRepository: ref.read(sessionRepositoryProvider),
    firebaseStorageRepository: ref.read(firebaseStorageRepositoryProvider),
    firebaseStoreRespository: ref.read(recipeFirebaseRepositoryProvider),
    authRepository: ref.watch(firebaseAuthRepositoryProvider),
  ),
);

@RoutePage()
class CreateScreen extends BaseView {
  const CreateScreen({super.key});

  @override
  BaseViewState<CreateScreen, CreateViewModel> createState() =>
      _CreateViewState();
}

class _CreateViewState extends BaseViewState<CreateScreen, CreateViewModel> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isExpanded = false;
  bool _isClickIcon = false;
  final animationDuration = const Duration(milliseconds: 250);
  final opacityAnimationDuration = const Duration(milliseconds: 150);

  @override
  Future<void> onInitState() async {
    super.onInitState();
    await Future.delayed(Duration.zero, () async {
      await viewModel.initData();
    });
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return CreateAppBar(
        title: screenName,
        backgroundColor: backgroundColor,
        onSaveIconTap: _saveRecipeInFirebase,
        onAnalyzeIconTap: _getAnalyzeRecipe,
        isCanSave: state.isUpload);
  }

  Future<void> _saveRecipeInFirebase() async {
    await viewModel.uploadRecipe();
    final formState = _formKey.currentState;
    formState?.reset();
  }

  Future<void> _getAnalyzeRecipe() async {
    final formState = _formKey.currentState;

    if (formState != null) {
      if (formState.validate()) {
        formState.save();
        await viewModel.getAnalyzeRecipe();
        await _showDialogResultAnalyze();
      }
    }
  }

  Future<void> _showDialogResultAnalyze() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: ResultAnalyzeRecipe(
                recipe: state.recipe!, image: state.imageData),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.keyboard_arrow_right_sharp))
            ],
          );
        });
  }

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ImageFromGalleryEx(
                onSaved: (value) {
                  viewModel.saveImage(value);
                },
              ),
            ),
            _textFormIntroduce(context),
            _diverBelow(context),
            _textFormIngredient(),
            _listIngredient(),
            _diverBelow(context),
            _textFormInstruction(),
          ],
        ),
      ),
    );
  }

  Widget _textFormIngredient() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)?.ingredient ?? "Ingredient",
              style: AppTextStyles.titleMedium,
            ),
          ),
          AnimatedContainer(
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            duration: animationDuration,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: _isExpanded
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  width: _isExpanded ? 1 : 0,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(24),
                )),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      _isClickIcon = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _isClickIcon = false;
                    });
                  },
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: AnimatedOpacity(
                    opacity: _isClickIcon ? 0.7 : 1,
                    duration: opacityAnimationDuration,
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24))),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: AnimatedContainer(
                    duration: animationDuration,
                    curve: Curves.easeInOut,
                    width: _isExpanded ? 200 : 0,
                    child: TextField(
                      onTapOutside: (_) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      onChanged: (value) async {
                        await viewModel.getCompletedIngredient(value);
                      },
                      style: AppTextStyles.bodyMedium,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)?.complete_text,
                          hintStyle: AppTextStyles.hintBodySmall),
                    ),
                  ),
                )
              ],
            ),
          ),
          if (_isExpanded)
            AnimatedContainer(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              curve: Curves.easeInOut,
              decoration: const BoxDecoration(
                color: ColorName.orange0DEE6723,
              ),
              height: (state.listIngredientComplete ?? []).isNotEmpty ? 200 : 0,
              duration: animationDuration,
              child: ListView.builder(
                itemCount: state.listIngredientComplete?.length,
                itemBuilder: (context, index) {
                  final option = state.listIngredientComplete?[index];
                  return ListTile(
                    leading: CachedNetworkImage(
                        width: 40,
                        height: 40,
                        imageUrl:
                            "https://img.spoonacular.com/ingredients_100x100/${option?.image}"),
                    title: Text(
                      option?.name ?? "",
                      style: AppTextStyles.bodySmall,
                    ),
                    onTap: () {
                      if (option != null) viewModel.addToListIngredient(option);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _listIngredient() {
    return SliverList.builder(
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(state.listIngredient?[index].name ?? index.toString()),
          onDismissed: (direction) {
            Ingredient? ingredientRemove = state.listIngredient?[index];
            viewModel.removeIngredient(index);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Undo remove ingredient!'),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'Undo',
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (ingredientRemove != null) {
                      viewModel.undoRemoveIngredient(ingredientRemove, index);
                    }
                  },
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: IngredientCreateView(
              ingredient: state.listIngredient![index],
              onSubmit: (value) {
                viewModel.saveIngredient(value, index);
              },
            ),
          ),
        );
      },
      itemCount: state.listIngredient?.length,
    );
  }

  Widget _textFormInstruction() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)?.intructions ?? "Intructions",
              style: AppTextStyles.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              maxLines: 500,
              minLines: 2,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)?.intructions,
                hintStyle: AppTextStyles.hintBodySmall,
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              onSaved: (value) {
                viewModel.saveInstructions(value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)?.complete_text;
                }
                return null;
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _textFormIntroduce(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextFormField(
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)?.title_recipe,
              label: Text(
                  AppLocalizations.of(context)?.title_recipe ?? "Name recipe"),
              labelStyle: AppTextStyles.titleMedium,
              hintStyle: AppTextStyles.hintBodySmall,
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            onSaved: (value) {
              viewModel.saveTitle(value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)?.complete_text;
              }
              return null;
            },
          ),
          const SizedBox(
            height: 16,
          ),
          TextFormField(
            maxLines: 3,
            minLines: 2,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)?.sumary_recipe,
              hintStyle: AppTextStyles.hintBodySmall,
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            onSaved: (value) {
              viewModel.saveSummary(value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)?.complete_text;
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(AppLocalizations.of(context)?.serving ?? "Serving"),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: "1",
                    keyboardType: TextInputType.number,
                    style: AppTextStyles.bodyMedium,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)?.serving,
                      hintStyle: AppTextStyles.hintBodySmall,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    onSaved: (value) {
                      viewModel.saveServing(int.tryParse(value ?? "1"));
                    },
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null) {
                        return AppLocalizations.of(context)?.complete_text;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(AppLocalizations.of(context)?.ready_in_minutes ??
                    "Ready in minutes"),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: "30",
                    keyboardType: TextInputType.number,
                    style: AppTextStyles.bodyMedium,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)?.ready_in_minutes,
                      hintStyle: AppTextStyles.hintBodySmall,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    onSaved: (value) {
                      viewModel.saveReadyInMinues(int.tryParse(value ?? "0"));
                    },
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null) {
                        return AppLocalizations.of(context)?.complete_text;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(AppLocalizations.of(context)?.cooking_in_minute ??
                    "Cooking in minute"),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: "30",
                    keyboardType: TextInputType.number,
                    style: AppTextStyles.bodyMedium,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)?.cooking_in_minute,
                      hintStyle: AppTextStyles.hintBodySmall,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    onSaved: (value) {
                      viewModel.saveCookingInMinues(int.tryParse(value ?? "1"));
                    },
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null) {
                        return AppLocalizations.of(context)?.complete_text;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  Widget _diverBelow(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Divider(
        height: 16,
        thickness: 8,
        color: ColorName.orange12EE6723,
      ),
    );
  }

  @override
  String get screenName => CreateRoute.name;

  @override
  CreateViewModel get viewModel => ref.read(_provider.notifier);

  CreateState get state => ref.watch(_provider);
}
