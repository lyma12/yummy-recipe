import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/components/divider/divider_horizontal.dart';
import 'package:base_code_template_flutter/components/loading/container_with_loading.dart';
import 'package:base_code_template_flutter/components/loading/loading_view_model.dart';
import 'package:base_code_template_flutter/components/web_components/web_view_container.dart';
import 'package:base_code_template_flutter/data/models/queries/queries.dart';
import 'package:base_code_template_flutter/data/providers/hive_storage_provider.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:base_code_template_flutter/router/app_router.dart';
import 'package:base_code_template_flutter/screens/setting/queries/queries_setting_state.dart';
import 'package:base_code_template_flutter/screens/setting/queries/queries_setting_view_model.dart';
import 'package:base_code_template_flutter/utilities/constants/text_constants.dart';
import 'package:base_code_template_flutter/utilities/exceptions/extension.dart';
import 'package:base_code_template_flutter/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

import '../../../components/base_view/base_view.dart';

final _provider = StateNotifierProvider.autoDispose<QueriesSettingViewModel,
    QueriesSettingState>(
  (ref) => QueriesSettingViewModel(
    ref: ref,
    hiveStorage: ref.read(hiveStorageProvider),
  ),
);

@RoutePage()
class QueriesSettingScreen extends BaseView {
  const QueriesSettingScreen({super.key, @Path('nextRoute') this.nextRoute});

  final PageRouteInfo? nextRoute;

  @override
  BaseViewState<QueriesSettingScreen, QueriesSettingViewModel> createState() =>
      _QueriesSettingViewState();
}

class _QueriesSettingViewState
    extends BaseViewState<QueriesSettingScreen, QueriesSettingViewModel> {
  bool isGetInfo = false;
  bool isOpenWebView = false;
  double _previousScrollOffset = 0.0;
  final ScrollController _scrollController = ScrollController();

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Future<void> onInitState() async {
    super.onInitState();
    _scrollController.addListener(_onScroll);
    await _onInitData();
  }

  @override
  Widget buildBody(BuildContext context) {
    final dietOptions = viewModel.dietOptions;
    final cuisineOption = viewModel.cuisineOptions;
    final mealTypeOptions = viewModel.mealTypeOptions;
    final intoleranceOptions = viewModel.intoleranceOptions;

    final dietState = state.diets;
    final cuisineState = state.cuisine;
    final mealTypeState = state.mealTypes;
    final intoleranceState = state.intolerances;
    return ContainerWithLoading(
        child: Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppLocalizations.of(context)?.queries_question ??
                "Queries suggestion: ",
            style: AppTextStyles.titleLargeBold,
          ),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                isGetInfo = !isGetInfo;
                if (isGetInfo) isOpenWebView = true;
              });
            },
            icon: const Icon(Icons.info_outlined)),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isGetInfo ? 300 : 0,
          child: isOpenWebView
              ? Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: const WebViewContainer(
                      uri: TextConstants.webViewSpoonacular),
                )
              : const SizedBox.shrink(),
          onEnd: () {
            setState(() {
              if (isOpenWebView) {
                if (!isGetInfo) {
                  isOpenWebView = false;
                }
              }
            });
          },
        ),
        const DividerHorizontal(
          height: 1,
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)?.diet_question ?? "",
                    style: AppTextStyles.titleMedium,
                  ),
                  _buildCheckBoxListTitle<Diet>(dietOptions, dietState),
                  const DividerHorizontal(
                    height: 1,
                  ),
                  Text(
                    AppLocalizations.of(context)?.cuisine_question ??
                        "Is there a local dish you would like to try?",
                    style: AppTextStyles.titleMedium,
                  ),
                  DropdownButton<Cuisine>(
                    hint: Text(Cuisine.none.name),
                    value: cuisineState,
                    onChanged: (Cuisine? newValue) {
                      viewModel.setCuisine(newValue);
                    },
                    items: cuisineOption
                        .map<DropdownMenuItem<Cuisine>>((Cuisine value) {
                      return DropdownMenuItem<Cuisine>(
                        value: value,
                        child:
                            Text(Utilities.formatEnumQueriesName(value.name)),
                      );
                    }).toList(),
                  ),
                  const DividerHorizontal(
                    height: 1,
                  ),
                  Text(
                    AppLocalizations.of(context)?.meal_type_question ?? "",
                    style: AppTextStyles.titleMedium,
                  ),
                  _buildCheckBoxListTitle<MealType>(
                      mealTypeOptions, mealTypeState),
                  const DividerHorizontal(
                    height: 1,
                  ),
                  Text(
                    AppLocalizations.of(context)?.intolerance_question ?? "",
                    style: AppTextStyles.titleMedium,
                  ),
                  _buildCheckBoxListTitle<Intolerance>(
                      intoleranceOptions, intoleranceState),
                  const DividerHorizontal(
                    height: 2,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await onSave();
                    },
                    child: Text(AppLocalizations.of(context)?.save ?? "Save"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildCheckBoxListTitle<T>(
    List<T> listData,
    List<bool> listDataState,
  ) {
    return Column(
      children: listData.mapIndexed((index, data) {
        return CheckboxListTile(
          title: Text(Utilities.formatEnumQueriesName(data.toString())),
          value: listDataState[index],
          onChanged: (check) {
            if (T == Diet) {
              viewModel.setDiet(index);
            } else if (T == MealType) {
              viewModel.setMealType(index);
            } else if (T == Intolerance) {
              viewModel.setIntolerance(index);
            }
          },
        );
      }).toList(),
    );
  }

  Future<void> _onInitData() async {
    Object? error;
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

  void _onScroll() {
    double currentScrollOffset = _scrollController.position.pixels;
    bool isScrollDown = false;
    if (currentScrollOffset > _previousScrollOffset) {
      isScrollDown = true;
    }
    _previousScrollOffset = currentScrollOffset;

    if (isScrollDown && isGetInfo) {
      setState(() {
        if (isGetInfo) isGetInfo = false;
      });
    }
  }

  Future<void> onSave() async {
    Object? error;
    await loading.whileLoading(context, () async {
      try {
        await viewModel.saveData();
        final nextRoute = widget.nextRoute;
        if (nextRoute != null && mounted) {
          await AutoRouter.of(context).replace(nextRoute);
        }
      } catch (e) {
        error = e;
      }
    });
    if (error != null) {
      await handleError(error!);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  String get screenName => QueriesSettingRoute.name;

  QueriesSettingState get state => ref.watch(_provider);

  LoadingStateViewModel get loading => ref.read(loadingStateProvider.notifier);

  @override
  QueriesSettingViewModel get viewModel => ref.read(_provider.notifier);
}
