import 'dart:io';

import 'package:base_code_template_flutter/data/models/user/user_firebase_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_setting_state.freezed.dart';

@freezed
class ProfileSettingState with _$ProfileSettingState {
  const factory ProfileSettingState({
    File? avatarFile,
    UserFirebaseProfile? profile,
  }) = _ProfileSettingState;

  const ProfileSettingState._();
}
