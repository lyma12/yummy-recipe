import 'dart:async';

import 'package:base_code_template_flutter/data/models/user/user_firebase_profile.dart';
import 'package:base_code_template_flutter/data/repositories/firebase/user_firebase_store_repository.dart';
import 'package:base_code_template_flutter/data/repositories/signin/signin_repository.dart';
import 'package:base_code_template_flutter/data/services/hive_storage/hive_storage.dart';
import 'package:base_code_template_flutter/screens/account/account_state.dart';

import '../../../components/base_view/base_view_model.dart';

class AccountViewModel extends BaseViewModel<AccountState> {
  AccountViewModel({
    required this.firebaseAuthRepository,
    required this.userProfileRepository,
    required this.hiveStorage,
  }) : super(const AccountState());

  final AuthRepository firebaseAuthRepository;
  final UserProfileRepository userProfileRepository;
  final HiveStorage hiveStorage;
  Stream<UserFirebaseProfile?>? _profileStream;

  Future<void> initData() async {
    final data = firebaseAuthRepository.getUserProfile();
    final firebaseProfile = await userProfileRepository.loadProfile(data.id);
    if (firebaseProfile == null) {
      unawaited(userProfileRepository.editProfile(data));
    }
    _listenToProfile(data.id);
    state = state.copyWith(
      profile: data,
    );
  }

  void _listenToProfile(String id) {
    _profileStream = userProfileRepository.listenProfile(id);
    _profileStream?.listen((pf) {
      if (mounted) {
        state = state.copyWith(profile: pf);
      }
    });
  }

  Future<void> signOut() async {
    await hiveStorage.clearDataAccount();
    await firebaseAuthRepository.signOut();
  }
}
