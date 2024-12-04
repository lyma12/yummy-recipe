import 'package:base_code_template_flutter/screens/video/calendar_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/base_view/base_view_model.dart';

class CalendarViewModel extends BaseViewModel<CalendarState> {
  CalendarViewModel({required this.ref}) : super(const CalendarState());

  final Ref ref;

  Future<void> initData() async {
    state =
        state.copyWith(selectedDay: DateTime.now(), focusedDay: DateTime.now());
  }

  void selectDay(DateTime selectDay, DateTime focusedDay) {
    state = state.copyWith(
      selectedDay: selectDay,
      focusedDay: focusedDay,
    );
  }
}
