import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/components/dialog/create_shopping_dialog.dart';
import 'package:base_code_template_flutter/components/dialog/dialog_provider.dart';
import 'package:base_code_template_flutter/components/internet/internet_provider.dart';
import 'package:base_code_template_flutter/components/loading/loading_view_model.dart';
import 'package:base_code_template_flutter/data/models/user/spoonacular_account.dart';
import 'package:base_code_template_flutter/data/providers/auth_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/hive_storage_provider.dart';
import 'package:base_code_template_flutter/data/providers/recipe_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/secure_storage_provider.dart';
import 'package:base_code_template_flutter/data/providers/user_provider.dart';
import 'package:base_code_template_flutter/router/app_router.dart';
import 'package:base_code_template_flutter/screens/meal_plan/components/item_shopping_list.dart';
import 'package:base_code_template_flutter/screens/meal_plan/shopping_list/shopping_list_state.dart';
import 'package:base_code_template_flutter/screens/meal_plan/shopping_list/shopping_list_view_model.dart';
import 'package:base_code_template_flutter/utilities/utilities.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../components/base_view/base_view.dart';
import '../../../resources/app_text_styles.dart';

final providerShoppingList =
    StateNotifierProvider.autoDispose<ShoppingListViewModel, ShoppingListState>(
  (ref) => ShoppingListViewModel(
    ref: ref,
    firebaseAuth: ref.read(firebaseAuthRepositoryProvider),
    spoonacularRepository: ref.read(recipeSpoonacularRepositoryProvider),
    userProfileRepository: ref.read(userProfileProvider),
    secureStorageManager: ref.read(secureStorageProvider),
    hiveStorage: ref.read(hiveStorageProvider),
  ),
);

/// Screen code: A_04
@RoutePage()
class ShoppingListScreen extends BaseView {
  const ShoppingListScreen({
    super.key,
    required this.user,
  });

  final SpoonacularAccount user;

  @override
  BaseViewState<ShoppingListScreen, ShoppingListViewModel> createState() =>
      _ShoppingListViewState();
}

class _ShoppingListViewState
    extends BaseViewState<ShoppingListScreen, ShoppingListViewModel>
    with AutomaticKeepAliveClientMixin {
  DateTime timeNow = DateTime.now();
  ScrollController? controller;

  @override
  Future<void> onInitState() async {
    super.onInitState();
    await _onInitData();
  }

  Future<void> _onInitData() async {
    Object? error;
    await loading.whileLoading(context, () async {
      try {
        await viewModel.initData(widget.user);
      } catch (e) {
        error = e;
      }
    });

    if (error != null) {
      handleError(error!);
    }
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildBody(context);
  }

  @override
  Widget buildBody(BuildContext context) {
    return RefreshIndicator(
      child: CustomScrollView(
        slivers: [
          _topPageView(),
          _listItem(),
        ],
      ),
      onRefresh: () async {
        await refreshItem();
      },
    );
  }

  Widget _topPageView() {
    final cost = state.cost;
    final startDateInt = state.timeStart;
    final endDateInt = state.timeEnd;
    String? stringDate;
    if (startDateInt != null && endDateInt != null) {
      final startDate = Utilities.formatDateTimeFromSpoonacular(startDateInt);
      final endDate = Utilities.formatDateTimeFromSpoonacular(endDateInt);
      stringDate = "Date: $startDate - $endDate";
    }
    return SliverAppBar(
      title: ListTile(
        title: Text(
          "Estimated Total Cost = $cost",
          style: AppTextStyles.titleSmallBold,
        ),
        subtitle: (stringDate != null) ? Text(stringDate) : null,
      ),
      actions: [
        IconButton(
            onPressed: () async {
              await showDialogCreateShoppingList();
            },
            icon: const Icon(Icons.add)),
      ],
    );
  }

  Future showDialogCreateShoppingList() async {
    await ref.read(alertDialogProvider).showAlertDialog(
          context: context,
          dialog: CreateShoppingDialog(onSubmit: (item, aisle) async {
            await addItemShoppingList(item, aisle);
          }),
          barrierDismissible: true,
        );
  }

  Widget _listItem() {
    final listItem = state.listItemShopping;

    List<Widget> itemWidgets = [];
    listItem.forEach((key, value) {
      itemWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Text(
            key,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
      if (value.isNotEmpty) {
        itemWidgets.add(
          ItemShoppingList(
            onDeleteItem: (id) async {
              await removeItemShoppingList(id, key);
            },
            items: value,
            onCheckBox: (id) {
              viewModel.setCheckBoxItemShoppingList(id, key);
            },
            stateItems: state.listItemState[key] ?? {},
          ),
        );
        itemWidgets.add(const Divider());
      } else {
        itemWidgets.add(const SizedBox.shrink());
      }
    });

    return SliverList(
      delegate: SliverChildListDelegate(itemWidgets),
    );
  }

  Future removeItemShoppingList(int id, String aisleKey) async {
    Object? error;
    await loading.whileLoading(context, () async {
      try {
        await viewModel.deleteItemShoppingList(id, aisleKey);
      } catch (e) {
        error = e;
      }
    });

    if (error != null) {
      handleError(error!);
    }
  }

  Future addItemShoppingList(String item, String aisle) async {
    Object? error;
    await loading.whileLoading(
      context,
      () async {
        try {
          if (ref.read(internetProvider)) {
            viewModel.addItemShoppingList(item, aisle).then(
              (_) {
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
            );
          } else {
            throw DioException.connectionError(
                reason: 'internet error connect!',
                requestOptions: RequestOptions());
          }
        } catch (e) {
          error = e;
        }
      },
    );
    if (error != null) {
      handleError(error!);
    }
  }

  Future refreshItem() async {
    Object? error;
    await loading.whileLoading(
      context,
      () async {
        try {
          await viewModel.reLoad();
        } catch (e) {
          error = e;
        }
      },
    );

    if (error != null) {
      handleError(error!);
    }
  }

  @override
  void onDispose() async {
    await viewModel.saveShoppingListStateToFirebase();
    super.onDispose();
  }

  @override
  ShoppingListViewModel get viewModel =>
      ref.read(providerShoppingList.notifier);

  ShoppingListState get state => ref.watch(providerShoppingList);

  LoadingStateViewModel get loading => ref.read(loadingStateProvider.notifier);

  @override
  String get screenName => MealPlanRoute.name;

  @override
  bool get wantKeepAlive => true;
}
