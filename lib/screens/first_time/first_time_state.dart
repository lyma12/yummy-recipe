import 'package:freezed_annotation/freezed_annotation.dart';

part 'first_time_state.freezed.dart';

@freezed
class FirstTimeState with _$FirstTimeState {
  const factory FirstTimeState({
    @Default(0) int currentPage,
    @Default(false) bool isFirstTime,
  }) = _FirstTimeState;

  const FirstTimeState._();
}
