import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_state.freezed.dart';

@freezed
class CalendarState with _$CalendarState {
  const factory CalendarState({
    DateTime? selectedDay,
    DateTime? focusedDay,
  }) = _CalendarState;

  const CalendarState._();
}
