import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    User? user,
    String? email,
    String? password,
    String? emailException,
    String? passwordException,
  }) = _LoginState;

  const LoginState._();
}
