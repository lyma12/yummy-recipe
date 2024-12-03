import 'dart:io';

import 'package:base_code_template_flutter/components/base_view/base_view_model.dart';
import 'package:base_code_template_flutter/data/models/user/user_firebase_profile.dart';
import 'package:base_code_template_flutter/data/repositories/firebase/firebase_storage_repository.dart';
import 'package:base_code_template_flutter/data/repositories/firebase/user_firebase_store_repository.dart';
import 'package:base_code_template_flutter/data/repositories/signin/signin_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'profile_setting_state.dart';

class ProfileSettingViewModel extends BaseViewModel<ProfileSettingState> {
  ProfileSettingViewModel({
    required this.ref,
    required this.firebaseAuth,
    required this.firebaseStorageRepository,
    required this.userProfileRepository,
  }) : super(const ProfileSettingState());
  final Ref ref;
  final AuthRepository firebaseAuth;
  final FirebaseStorageRepository firebaseStorageRepository;
  final UserProfileRepository userProfileRepository;

  Future<void> initData() async {
    UserFirebaseProfile profile = firebaseAuth.getUserProfile();
    final firebaseProfile = await userProfileRepository.loadProfile(profile.id);
    if (kDebugMode) {
      print(firebaseProfile);
    }
    if (firebaseProfile != null) {
      profile = firebaseProfile;
    }
    state = state.copyWith(
      profile: profile,
    );
  }

  void saveImageAvatar(File? avatar) {
    state = state.copyWith(
      avatarFile: avatar,
    );
  }

  void saveName(String name) {
    var profile = state.profile;
    if (profile == null) return;
    state = state.copyWith(
      profile: profile.copyWith(
        name: name,
      ),
    );
  }

  void saveAddress(String? address) {
    var profile = state.profile;
    if (profile == null) return;
    state = state.copyWith(
      profile: profile.copyWith(
        address: address,
      ),
    );
  }

  void saveIntroduce(String? introduce) {
    var profile = state.profile;
    if (profile == null) return;
    state = state.copyWith(
      profile: profile.copyWith(
        introduce: introduce,
      ),
    );
  }

  Future<void> saveProfile() async {
    UserFirebaseProfile? profile = state.profile;
    final avatar = state.avatarFile;
    if (profile == null) {
      return;
    }
    if (avatar != null) {
      final imageUrl =
          await firebaseStorageRepository.saveAvatar(profile.id, avatar);
      profile = profile.copyWith(
        imageUrl: imageUrl,
      );
    }
    await firebaseAuth.editProfile(profile);
    await userProfileRepository.editProfile(profile);
  }
}
