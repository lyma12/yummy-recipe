import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/components/app_bar/calendar_screen_bar.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:base_code_template_flutter/resources/gen/colors.gen.dart';
import 'package:base_code_template_flutter/screens/video/calendar_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../components/base_view/base_view.dart';
import '../../router/app_router.dart';
import 'calendar_view_model.dart';

final _provider =
    StateNotifierProvider.autoDispose<CalendarViewModel, CalendarState>(
  (ref) => CalendarViewModel(ref: ref),
);

/// Screen code: A_04
@RoutePage()
class CalendarScreen extends BaseView {
  const CalendarScreen({super.key});

  @override
  BaseViewState<CalendarScreen, CalendarViewModel> createState() =>
      _VideoViewState();
}

class _VideoViewState extends BaseViewState<CalendarScreen, CalendarViewModel>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  DateTime timeNow = DateTime.now();
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
    Tab(
      icon: Icon(
        Icons.create,
        size: 20,
      ),
    ),
  ];

  @override
  Future<void> onInitState() async {
    super.onInitState();
    initTabController();
    await Future.delayed(Duration.zero, () async {
      await _onInitData();
    });
  }

  Future<void> _onInitData() async {
    await viewModel.initData();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  TabController initTabController() {
    _tabController ??= TabController(length: 3, vsync: this);
    return _tabController!;
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => CalendarScreenBar(
        tabController: _tabController ?? initTabController(),
        tabs: tabs,
      );

  @override
  Widget buildBody(BuildContext context) {
    return TabBarView(controller: _tabController, children: <Widget>[
      const Text("Shopping list"),
      _calendarView(),
      const Text("Create"),
    ]);
  }

  Widget _calendarView() {
    return TableCalendar(
      daysOfWeekHeight: 30,
      calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: AppTextStyles.titleSmall,
          selectedDecoration: const BoxDecoration(
            color: ColorName.orange33EE6723,
            shape: BoxShape.circle,
          )),
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
          titleTextFormatter: (date, locate) =>
              DateFormat.yMMMM(locate).format(date).toUpperCase(),
          formatButtonVisible: false,
          titleCentered: true),
      startingDayOfWeek: StartingDayOfWeek.monday,
      focusedDay: timeNow,
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      selectedDayPredicate: (day) => isSameDay(day, state.selectedDay),
      onDaySelected: (selectedDay, focusedDay) =>
          viewModel.selectDay(selectedDay, focusedDay),
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          return Center(
              child: Text(
            DateFormat.E('en_US').format(day)[0].toUpperCase(),
          ) // will change locate before
              );
        },
      ),
    );
  }

  @override
  CalendarViewModel get viewModel => ref.read(_provider.notifier);

  CalendarState get state => ref.watch(_provider);

  @override
  String get screenName => CalendarRoute.name;
}
