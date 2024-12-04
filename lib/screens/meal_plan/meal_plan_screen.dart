import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/components/app_bar/meal_screen_bar.dart';
import 'package:base_code_template_flutter/components/loading/container_with_loading.dart';
import 'package:base_code_template_flutter/components/loading/loading_view_model.dart';
import 'package:base_code_template_flutter/components/permission/container_with_permission.dart';
import 'package:base_code_template_flutter/components/permission/permission_view_model.dart';
import 'package:base_code_template_flutter/data/providers/auth_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/recipe_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/secure_storage_provider.dart';
import 'package:base_code_template_flutter/data/providers/user_provider.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:base_code_template_flutter/router/app_router.dart';
import 'package:base_code_template_flutter/screens/meal_plan/calendar/calendar_screen.dart';
import 'package:base_code_template_flutter/screens/meal_plan/shopping_list/shopping_list_screen.dart';
import 'package:base_code_template_flutter/screens/meal_plan/shopping_list/shopping_list_view_model.dart';
import 'package:base_code_template_flutter/utilities/exceptions/spoonacular_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../components/base_view/base_view.dart';
import 'meal_plan_state.dart';
import 'meal_plan_view_model.dart';

final _provider =
    StateNotifierProvider.autoDispose<MealPlanViewModel, MealPlanState>(
  (ref) => MealPlanViewModel(
    ref: ref,
    userFirebaseRepository: ref.read(userProfileProvider),
    firebaseAuth: ref.read(firebaseAuthRepositoryProvider),
    spoonacularRepository: ref.read(recipeSpoonacularRepositoryProvider),
    secureStorageManager: ref.read(secureStorageProvider),
  ),
);

/// Screen code: A_04
@RoutePage()
class MealPlanScreen extends BaseView {
  const MealPlanScreen({super.key});

  @override
  BaseViewState<MealPlanScreen, MealPlanViewModel> createState() =>
      _VideoViewState();
}

class _VideoViewState extends BaseViewState<MealPlanScreen, MealPlanViewModel>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  bool _hasCheckedPermission = false;
  final permissions = [Permission.calendarFullAccess];
  final tabs = const <Widget>[
    Tab(
      icon: Icon(
        Icons.shopping_basket_outlined,
        size: 20,
      ),
    ),
    Tab(
      icon: Icon(
        Icons.calendar_month,
        size: 20,
      ),
    ),
  ];

  @override
  Future<void> onInitState() async {
    super.onInitState();
    WidgetsBinding.instance.addObserver(this);
    await permission.checkAndRequestPermissions(permissions).then((_) async {
      initTabController();
      await Future.delayed(Duration.zero, () async {
        await _onInitData();
      });
    });
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

  Future<void> _connectSpoonacular() async {
    Object? error;
    await loading.whileLoading(context, () async {
      try {
        await viewModel.connectSpoonacular();
      } catch (e) {
        error = e;
      }
    });

    if (error != null) {
      handleError(error!);
    }
  }

  Widget showPermissionConnectDialog(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)?.connect_spoonacular ??
                  "Connect to Spoonacular",
              style: AppTextStyles.titleSmallBold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)?.queries_question ??
                  "Would you like to connect your Spoonacular account to access recipes and other information?",
              textAlign: TextAlign.center,
              style: AppTextStyles.titleSmall,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await _connectSpoonacular();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(AppLocalizations.of(context)?.accept ?? "Accept"),
            ),
            TextButton(
              onPressed: () {
                handleError(SpoonacularConnectException());
              },
              child: Text(AppLocalizations.of(context)?.cancel ?? "Cancel"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _tabController?.dispose();
  }

  TabController initTabController() {
    _tabController ??= TabController(
      length: 2,
      vsync: this,
      initialIndex: 1,
    );
    return _tabController!;
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => MealScreenBar(
        tabController: _tabController ?? initTabController(),
        tabs: tabs,
      );

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      await shoppingListViewModel.saveShoppingListStateToFirebase();
      _hasCheckedPermission = true;
    } else if (state == AppLifecycleState.resumed && _hasCheckedPermission) {
      permission.checkAndRequestPermissions(permissions);
      _hasCheckedPermission = false;
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    final user = state.user;
    return ContainerWithPermissions(
      permissions: permissions,
      child: ContainerWithLoading(
        child: state.isConnectSpoonacular
            ? TabBarView(
                controller: _tabController,
                children: <Widget>[
                  if (user != null)
                    ShoppingListScreen(
                      user: user,
                    ),
                  if (user != null)
                    CalendarScreen(
                      user: user,
                    ),
                ],
              )
            : showPermissionConnectDialog(context),
      ),
    );
  }

  ShoppingListViewModel get shoppingListViewModel =>
      ref.read(providerShoppingList.notifier);

  @override
  MealPlanViewModel get viewModel => ref.read(_provider.notifier);

  MealPlanState get state => ref.watch(_provider);

  LoadingStateViewModel get loading => ref.read(loadingStateProvider.notifier);

  PermissionViewModel get permission =>
      ref.read(permissionStateProvider.notifier);

  @override
  String get screenName => MealPlanTabRoute.name;
}
