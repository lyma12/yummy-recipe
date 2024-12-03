import 'package:base_code_template_flutter/data/models/user/user_firebase_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_state.freezed.dart';

@freezed
class AccountState with _$AccountState {
  const factory AccountState({
    UserFirebaseProfile? profile,
  }) = _AccountState;

  const AccountState._();
}
