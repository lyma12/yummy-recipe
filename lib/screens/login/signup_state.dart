import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_state.freezed.dart';

@freezed
class SignupState with _$SignupState {
  const factory SignupState({
    String? email,
    String? password,
    String? emailException,
    String? passwordException,
  }) = _SignupState;

  const SignupState._();
}
