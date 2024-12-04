import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/screens/main/main_view_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../components/base_view/base_view.dart';
import '../../router/app_router.dart';
import 'components/bottom_tab_bar.dart';
import 'main_view_model.dart';

final _provider =
    StateNotifierProvider.autoDispose<MainViewModel, MainViewState>(
  (ref) => MainViewModel(),
);

/// Screen code: A_02
@RoutePage()
class MainScreen extends BaseView {
  const MainScreen({super.key});

  @override
  BaseViewState<MainScreen, MainViewModel> createState() => _MainViewState();
}

class _MainViewState extends BaseViewState<MainScreen, MainViewModel> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  bool get ignoreSafeAreaBottom => false;

  @override
  Widget buildBody(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        HomeTabRoute(),
        MealPlanTabRoute(),
        CreateTabRoute(),
        FavouriteTabRoute(),
        AccountTabRoute(),
      ],
      animationDuration: const Duration(milliseconds: 150),
      transitionBuilder: (context, child, animation) {
        final tabsRouter = AutoTabsRouter.of(context);
        final currentTab = tabsRouter.activeIndex;
        final previousTab = tabsRouter.previousIndex ?? 0;
        final offsetX = currentTab < previousTab ? -1.0 : 1.0;
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(offsetX, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      resizeToAvoidBottomInset: true,
      bottomNavigationBuilder: (context, tabsRouter) {
        return BottomTabBar(tabsRouter: tabsRouter);
      },
    );
  }

  @override
  MainViewModel get viewModel => ref.read(_provider.notifier);

  MainViewState get state => ref.watch(_provider);

  @override
  String get screenName => MainRoute.name;
}
