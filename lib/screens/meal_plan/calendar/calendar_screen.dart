import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/components/bottom_sheet/meal_screen_bottom_sheet.dart';
import 'package:base_code_template_flutter/components/loading/container_with_loading.dart';
import 'package:base_code_template_flutter/components/loading/loading_view_model.dart';
import 'package:base_code_template_flutter/components/search_recipe/search_recipe_view.dart';
import 'package:base_code_template_flutter/data/models/user/spoonacular_account.dart';
import 'package:base_code_template_flutter/data/providers/auth_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/hive_storage_provider.dart';
import 'package:base_code_template_flutter/data/providers/recipe_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/secure_storage_provider.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:base_code_template_flutter/resources/gen/colors.gen.dart';
import 'package:base_code_template_flutter/router/app_router.dart';
import 'package:base_code_template_flutter/screens/meal_plan/calendar/calendar_state.dart';
import 'package:base_code_template_flutter/screens/meal_plan/calendar/calendar_view_model.dart';
import 'package:base_code_template_flutter/screens/meal_plan/components/meal_plan_day_view.dart';
import 'package:base_code_template_flutter/screens/meal_plan/components/nutrition_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../components/base_view/base_view.dart';
import '../../../components/dialog/dialog_provider.dart';

final mealPlanProvider =
    StateNotifierProvider.autoDispose<CalendarViewModel, CalendarState>(
  (ref) => CalendarViewModel(
    ref: ref,
    firebaseAuth: ref.read(firebaseAuthRepositoryProvider),
    spoonacularRepository: ref.read(recipeSpoonacularRepositoryProvider),
    hiveStorage: ref.read(hiveStorageProvider),
    secureStorageManager: ref.read(secureStorageProvider),
    recipeFirebaseStoreRepository: ref.read(recipeFirebaseRepositoryProvider),
  ),
);

/// Screen code: A_04
@RoutePage()
class CalendarScreen extends BaseView {
  const CalendarScreen({
    super.key,
    required this.user,
  });

  final SpoonacularAccount user;

  @override
  BaseViewState<CalendarScreen, CalendarViewModel> createState() =>
      _CalendarViewState();
}

class _CalendarViewState
    extends BaseViewState<CalendarScreen, CalendarViewModel>
    with AutomaticKeepAliveClientMixin {
  DateTime timeNow = DateTime.now();

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
      onRefresh: refreshItem,
      child: ContainerWithLoading(
        child: CustomScrollView(
          slivers: [
            _calendarView(),
            _dropButtonNutrition(),
            _nutritionChart(),
            _listMealPlanDayItem(),
          ],
        ),
      ),
    );
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

  Widget _calendarView() {
    return SliverAppBar(
      elevation: 2,
      pinned: true,
      toolbarHeight: 160,
      expandedHeight: 160,
      flexibleSpace: TableCalendar(
        daysOfWeekHeight: 30,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: const BoxDecoration(
            color: ColorName.orange33EE6723,
            shape: BoxShape.circle,
          ),
          todayTextStyle: AppTextStyles.titleSmall,
          selectedTextStyle: AppTextStyles.titleSmallWhite,
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        calendarFormat: CalendarFormat.week,
        headerStyle: HeaderStyle(
            titleTextFormatter: (date, locate) =>
                DateFormat.yMMMM(locate).format(date).toUpperCase(),
            formatButtonVisible: false,
            titleCentered: true),
        startingDayOfWeek: StartingDayOfWeek.monday,
        focusedDay: state.focusedDay ?? timeNow,
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        selectedDayPredicate: (day) => isSameDay(day, state.selectedDay),
        onHeaderTapped: (date) {
          _showDatePicker(context);
        },
        onDaySelected: (selectedDay, focusedDay) async =>
            getDataMealPlanDay(selectedDay, focusedDay),
        calendarBuilders: CalendarBuilders(
          dowBuilder: (context, day) {
            return Center(
                child: Text(
              DateFormat.E('en_US').format(day)[0].toUpperCase(),
            ));
          },
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: state.selectedDay ?? DateTime.now(),
      firstDate: DateTime.utc(2010, 10, 16),
      lastDate: DateTime.utc(2030, 3, 14),
      locale: Localizations.localeOf(context),
    );

    if (selectedDate != null) {
      await getDataMealPlanDay(selectedDate, selectedDate);
    }
  }

  Widget _nutritionChart() {
    final nutritionMealPlan = state.nutritionSummary;
    return SliverToBoxAdapter(
      child: nutritionMealPlan.isNotEmpty
          ? NutritionChart(nutrient: nutritionMealPlan)
          : const Divider(),
    );
  }

  Widget _dropButtonNutrition() {
    var nutritionType = state.nutritionType;
    final nutritionSummaryType = viewModel.nutritionSummaryType;
    return SliverToBoxAdapter(
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: nutritionType,
            elevation: 16,
            underline: Container(
              height: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
            items: nutritionSummaryType.map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
            onChanged: (value) {
              if (value == null) return;
              final indexType = nutritionSummaryType.indexOf(value);
              if (indexType == -1) return;
              viewModel.chooseNutritionType(indexType);
            },
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) => Scaffold(
                  body: MealScreenBottomSheet(
                    onTapBrowse: () async {
                      await browseRecipes();
                    },
                    onAddSaveRecipe: () async {
                      await addSaveRecipe();
                    },
                    onTapCreateRecipe: () async {
                      await createPersonalRecipe();
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () async {
              await _updateShoppingList();
            },
            icon: const Icon(Icons.shopping_bag_rounded),
          ),
        ],
      )),
    );
  }

  Future _updateShoppingList() async {
    Object? error;
    await loading.whileLoading(context, () async {
      try {
        await viewModel.updateShoppingList(state.selectedDay ?? DateTime.now());
      } catch (e) {
        error = e;
      }
    });

    if (error != null) {
      handleError(error!);
    }
  }

  Future browseRecipes() async {
    await ref.read(alertDialogProvider).showAlertDialog(
          context: context,
          dialog: SearchRecipeContainer(onSelect: (recipes, timeOfDate) async {
            if (recipes != null) {
              await viewModel.addMealPlanDay(
                  state.selectedDay ?? DateTime.now(), timeOfDate, recipes);
              if (mounted) {
                Navigator.of(context).pop();
              }
            }
          }),
          barrierDismissible: true,
        );
  }

  Future addSaveRecipe() async {
    AutoTabsRouter.of(context).setActiveIndex(3);
  }

  Future createPersonalRecipe() async {
    AutoTabsRouter.of(context).setActiveIndex(2);
  }

  Widget _listMealPlanDayItem() {
    final mealPlan = state.mealPlanDaySelect;
    return SliverToBoxAdapter(
      child: MealPlanDayView(
        mealPlan: mealPlan,
        onDismissItem: (int id) async {
          await removeItemPlanDay(id);
        },
      ),
    );
  }

  Future removeItemPlanDay(int id) async {
    Object? error;
    await loading.whileLoading(context, () async {
      try {
        await viewModel.removeItemMealPlanDay(id);
      } catch (e) {
        error = e;
      }
    });

    if (error != null) {
      handleError(error!);
    }
  }

  Future getDataMealPlanDay(DateTime selectDay, DateTime focusedDay) async {
    Object? error;
    await loading.whileLoading(context, () async {
      try {
        if (!isSameDay(selectDay, state.selectedDay)) {
          await viewModel.selectDay(selectDay, focusedDay);
        }
      } catch (e) {
        error = e;
      }
    });

    if (error != null) {
      handleError(error!);
    }
  }

  @override
  CalendarViewModel get viewModel => ref.read(mealPlanProvider.notifier);

  CalendarState get state => ref.watch(mealPlanProvider);

  LoadingStateViewModel get loading => ref.read(loadingStateProvider.notifier);

  @override
  String get screenName => MealPlanRoute.name;

  @override
  bool get wantKeepAlive => true;
}
