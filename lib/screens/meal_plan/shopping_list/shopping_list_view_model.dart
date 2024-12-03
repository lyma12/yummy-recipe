import 'dart:async';

import 'package:base_code_template_flutter/components/internet/internet_provider.dart';
import 'package:base_code_template_flutter/data/models/shopping_list/shopping_list.dart';
import 'package:base_code_template_flutter/data/models/user/spoonacular_account.dart';
import 'package:base_code_template_flutter/data/repositories/api/spoonacular/spoonacular_repository.dart';
import 'package:base_code_template_flutter/data/repositories/firebase/user_firebase_store_repository.dart';
import 'package:base_code_template_flutter/data/repositories/signin/signin_repository.dart';
import 'package:base_code_template_flutter/data/services/hive_storage/hive_storage.dart';
import 'package:base_code_template_flutter/screens/meal_plan/shopping_list/shopping_list_state.dart';
import 'package:base_code_template_flutter/utilities/utilities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/base_view/base_view_model.dart';
import '../../../components/home_widget/home_widget_service.dart';
import '../../../data/services/secure_storage/secure_storage_manager.dart';

class ShoppingListViewModel extends BaseViewModel<ShoppingListState> {
  ShoppingListViewModel({
    required this.ref,
    required this.firebaseAuth,
    required this.spoonacularRepository,
    required this.userProfileRepository,
    required this.secureStorageManager,
    required this.hiveStorage,
  }) : super(const ShoppingListState());

  final Ref ref;
  final AuthRepository firebaseAuth;
  final RecipeSpoonacularRepository spoonacularRepository;
  final UserProfileRepository userProfileRepository;
  SpoonacularAccount? user;
  final SecureStorageManager secureStorageManager;
  final HiveStorage hiveStorage;

  Future<void> initData(SpoonacularAccount user) async {
    this.user = user;
    _checkDataHaveChange();
    await _getShoppingList();
    _listenToInternetConnectivity();
  }

  Future _checkDataHaveChange() async {
    final isHaveDataChange =
        await secureStorageManager.readFlagChangeShoppingList();
    if (isHaveDataChange) {
      await _deleteShoppingListFromHive();
    }
  }

  void _listenToInternetConnectivity() {
    ref.listen<bool>(
      internetProvider,
      (previous, next) {
        if (next) {
          if (!(previous ?? false)) {
            _checkDataHaveChange();
          }
        }
      },
    );
  }

  Future<void> reLoad() async {
    await _getShoppingList();
  }

  Future<void> _getShoppingList() async {
    if (user == null) return;
    final userFirebaseId = firebaseAuth.getUserCredential().uid;
    if (ref.read(internetProvider)) {
      final isHaveDataInStore =
          await _loadShoppingListFromStorage(userFirebaseId);
      if (isHaveDataInStore) {
        unawaited(_loadShoppingListFromAPI(userFirebaseId));
      } else {
        await _loadShoppingListFromAPI(userFirebaseId);
      }
    } else {
      await _loadShoppingListFromStorage(userFirebaseId);
    }
  }

  Future<void> _loadShoppingListFromAPI(String userFirebaseId) async {
    try {
      final response = await spoonacularRepository.getShoppingList(user!);
      final responseState =
          await userProfileRepository.loadShoppingListState(userFirebaseId);

      if (response == null) {
        _updateStateToEmpty();
      } else {
        _updateStateWithData(response, responseState);
        await secureStorageManager
            .writeShoppingList(response.mapItemShoppingList);
      }
    } catch (e) {
      _updateStateToEmpty();
      rethrow;
    }
  }

  Future<bool> _loadShoppingListFromStorage(String userFirebaseId) async {
    try {
      final response = await secureStorageManager.readShoppingList();
      final responseState =
          await userProfileRepository.loadShoppingListState(userFirebaseId);

      if (response == null) {
        _updateStateToEmpty();
      } else {
        state = state.copyWith(
          listItemShopping: response,
          listItemState: responseState ?? {},
        );
      }
      return response != null;
    } catch (e) {
      _updateStateToEmpty();
      return false;
    }
  }

  void _updateStateToEmpty() {
    state = state.copyWith(
      cost: 0,
      timeEnd: null,
      timeStart: null,
      listItemShopping: {},
      listItemState: {},
    );
  }

  void _updateStateWithData(
      ShoppingList response, Map<String, Map<String, bool>>? responseState) {
    state = state.copyWith(
      listItemShopping: response.mapItemShoppingList,
      cost: response.cost ?? 0,
      timeStart: response.startDate,
      timeEnd: response.endDate,
      listItemState: responseState ?? response.state,
    );
  }

  void callbackUpdateState() {
    callbackUpdateItem(
      Utilities.formatDateTimeFromSpoonacular(
          state.timeStart ?? DateTime.now().microsecondsSinceEpoch),
      state.listItemShopping,
      state.listItemState,
    );
  }

  Future<void> saveShoppingListStateToFirebase() async {
    if (user == null) return;

    try {
      final userFirebase = firebaseAuth.getUserCredential();
      await userProfileRepository.saveShoppingList(
        state.listItemState,
        userFirebase.uid,
      );
    } catch (_) {
      if (!ref.read(internetProvider)) {
        await secureStorageManager.writeShoppingList(state.listItemShopping);
        await secureStorageManager.writeShoppingState(state.listItemState);
      }
    }
  }

  Future<void> deleteItemShoppingList(int id, String aisleKey) async {
    if (user == null) return;

    try {
      await spoonacularRepository.deleteFromShoppingList(user!, id);

      _removeItemFromState(id, aisleKey);
      callbackUpdateState();
    } catch (_) {
      if (!ref.read(internetProvider)) {
        _removeItemFromState(id, aisleKey);
        callbackUpdateState();
        await hiveStorage.saveDeleteShoppingList(id, aisleKey);
      }
    }
  }

  void _removeItemFromState(int id, String aisleKey) {
    final aisleItems = state.listItemShopping[aisleKey];
    final aisleState = state.listItemState[aisleKey];

    if (aisleItems != null) {
      final updatedItems = aisleItems.where((item) => item.id != id).toList();
      final updatedState =
          aisleState != null ? Map<String, bool>.from(aisleState) : null;
      updatedState?.remove(id.toString());

      final updatedShoppingMap =
          Map<String, List<ItemAisles>>.from(state.listItemShopping)
            ..[aisleKey] = updatedItems;
      final updatedStateMap =
          Map<String, Map<String, bool>>.from(state.listItemState)
            ..[aisleKey] = updatedState ?? {};

      state = state.copyWith(
        listItemShopping: updatedShoppingMap,
        listItemState: updatedStateMap,
      );
    }
  }

  Future<void> _deleteShoppingListFromHive() async {
    final shoppingListDelete = await hiveStorage.readDeleteShoppingList();
    for (var entry in shoppingListDelete.entries) {
      await deleteItemShoppingList(entry.key, entry.value);
    }
    await secureStorageManager.changeFlagShoppingList();
  }

  void setCheckBoxItemShoppingList(int id, String aisleKey) {
    final aisleItems = state.listItemState[aisleKey];
    if (aisleItems != null) {
      final updatedItems = aisleItems.map((key, item) {
        if (key == id.toString()) {
          return MapEntry(key, !item);
        }
        return MapEntry(key, item);
      });

      final updatedStateMap =
          Map<String, Map<String, bool>>.from(state.listItemState)
            ..[aisleKey] = updatedItems;

      state = state.copyWith(listItemState: updatedStateMap);
      callbackUpdateState();
    }
  }

  Future addItemShoppingList(String item, String aisle) async {
    if (user == null) return;
    ItemShoppingListRequest request = ItemShoppingListRequest(
      item: item,
      aisle: aisle,
      parse: true,
    );
    await spoonacularRepository.addShoppingList(user!, request);
    await _getShoppingList();
  }
}
