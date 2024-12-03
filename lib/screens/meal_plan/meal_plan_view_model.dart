import 'dart:async';

import 'package:base_code_template_flutter/data/repositories/api/spoonacular/spoonacular_repository.dart';
import 'package:base_code_template_flutter/data/repositories/firebase/user_firebase_store_repository.dart';
import 'package:base_code_template_flutter/data/repositories/signin/signin_repository.dart';
import 'package:base_code_template_flutter/data/services/secure_storage/secure_storage_manager.dart';
import 'package:base_code_template_flutter/utilities/exceptions/spoonacular_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/base_view/base_view_model.dart';
import '../../data/models/user/spoonacular_account.dart';
import 'meal_plan_state.dart';

class MealPlanViewModel extends BaseViewModel<MealPlanState> {
  MealPlanViewModel({
    required this.ref,
    required this.userFirebaseRepository,
    required this.firebaseAuth,
    required this.spoonacularRepository,
    required this.secureStorageManager,
  }) : super(const MealPlanState());

  final Ref ref;
  final UserProfileRepository userFirebaseRepository;
  final AuthRepository firebaseAuth;
  final RecipeSpoonacularRepository spoonacularRepository;
  SpoonacularAccount? userFirebase;
  final SecureStorageManager secureStorageManager;

  Future<void> initData() async {
    final userId = firebaseAuth.getUserCredential().uid;
    final isHaveDataInStore = await _getSpoonacularAccountInStore(userId);
    if (isHaveDataInStore) {
      unawaited(_getSpoonacularAccount(userId));
    } else {
      await (_getSpoonacularAccount(userId));
    }
  }

  Future<bool> _getSpoonacularAccountInStore(String uid) async {
    final saveData = await secureStorageManager.readSpoonacularAccount(uid);
    userFirebase = saveData;
    state = state.copyWith(
      user: saveData,
      isConnectSpoonacular:
          (saveData == null || saveData.userNameSpoonacular == null)
              ? false
              : true,
    );
    return saveData != null;
  }

  Future _getSpoonacularAccount(String uid) async {
    final user = await userFirebaseRepository.getSpoonacularAccount(uid);
    if (user != null) {
      await secureStorageManager.writeSpoonacularAccount(user);
    }
    userFirebase = user;
    state = state.copyWith(
      user: user,
      isConnectSpoonacular:
          (user == null || user.userNameSpoonacular == null) ? false : true,
    );
  }

  Future connectSpoonacular() async {
    final userAccount = firebaseAuth.getUserCredential();
    await spoonacularRepository.connectUser(
      userAccount,
      (hash, password, username) async {
        if (hash == null || hash.isEmpty) {
          throw SpoonacularException(message: 'can not connect spoonacular');
        }
        if (password == null || password.isEmpty) {
          throw SpoonacularException(message: 'can not connect spoonacular');
        }
        if (username == null || username.isEmpty) {
          throw SpoonacularException(message: 'can not connext spoonacular');
        }
        SpoonacularAccount account = SpoonacularAccount(
            hash: hash,
            spoonacularPassword: password,
            userNameSpoonacular: username);
        await userFirebaseRepository.addSpoonacularAccount(
          account,
          userAccount.uid,
        );
      },
    ).then((_) async {
      var user =
          await userFirebaseRepository.getSpoonacularAccount(userAccount.uid);
      state = state.copyWith(
        user: user,
        isConnectSpoonacular: true,
      );
    });
  }
}
