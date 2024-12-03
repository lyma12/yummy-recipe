import 'package:base_code_template_flutter/data/services/secure_storage/secure_storage_manager.dart';
import 'package:base_code_template_flutter/utilities/constants/app_options.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:home_widget/home_widget.dart';

import '../../data/models/shopping_list/shopping_list.dart';
import '../../data/models/user/spoonacular_account.dart';
import '../../data/repositories/api/spoonacular/spoonacular_repository.dart';
import '../../data/repositories/firebase/user_firebase_store_repository.dart';
import '../../data/repositories/signin/signin_repository.dart';
import '../../data/services/api/spoonacular/api_spoonacular_client.dart';
import '../../utilities/constants/text_constants.dart';
import '../../utilities/utilities.dart';

@pragma("vm:entry-point")
Future<void> interactiveCallback(Uri? uri) async {
  await Firebase.initializeApp();
  if (uri != null) {
    switch (uri.host) {
      case TextConstants.checkItemHost:
        int id = int.parse(uri.queryParameters[TextConstants.id] ?? '0');
        String item = uri.queryParameters[TextConstants.type] ?? '';
        await updateItemListShopping(item, id);
        break;
      case TextConstants.refreshItemHost:
        try {
          await HomeWidgetService().refreshDataShoppingList();
        } catch (e) {
          throw FirebaseException(plugin: 'open app', message: 'open app');
        }
    }
  }
}

Future<void> updateItemListShopping(String item, int id) async {
  var listItem = await HomeWidget.getWidgetData(TextConstants.keyListItem);
  if (listItem != null) {
    String itemList =
        Utilities.updateWhenCheckItemHomeWidget(listItem, item, id);
    try {
      await HomeWidgetService().updateItemListShoppingOnFirebase(itemList);
    } catch (e) {
      throw FirebaseException(plugin: "no app", message: "no app firebase");
    }
    HomeWidget.saveWidgetData(TextConstants.keyListItem, itemList);
    HomeWidget.updateWidget(
      name: TextConstants.homeWidgetName,
      androidName: TextConstants.homeWidgetName,
    );
  }
}

void callbackUpdateItem(
  String time,
  Map<String, List<ItemAisles>> listItem,
  Map<String, Map<String, bool>> stateList,
) async {
  HomeWidget.saveWidgetData(TextConstants.keyTitleHomeWidget, time);
  var items = Utilities.converterDataForHomeWidget(
    listItem,
    stateList,
  );
  HomeWidget.saveWidgetData(TextConstants.keyListItem, items);
  HomeWidget.updateWidget(
    name: TextConstants.homeWidgetName,
    androidName: TextConstants.homeWidgetName,
  );
}

class HomeWidgetService {
  final AuthRepository firebaseAuth = AuthRepositoryImpl();
  final RecipeSpoonacularRepository spoonacularRepository =
      RecipeSpoonacularRepositoryImpl(ApiSpoonacularClient(AppOptions.dioAPI));
  final UserProfileRepository userProfileRepository =
      UserFirebaseStoreRepositoryImpl(AppOptions.userProviderDocumentReference);
  final SecureStorageManager secureStorageManager =
      SecureStorageManager(const FlutterSecureStorage());
  SpoonacularAccount? user;

  Future refreshDataShoppingList() async {
    final id = firebaseAuth.getUserCredential().uid;
    user ??= await userProfileRepository.getSpoonacularAccount(id);
    if (user == null) return;
    final userFirebaseId = firebaseAuth.getUserCredential().uid;
    final response = await spoonacularRepository.getShoppingList(user!);
    final responseState =
        await userProfileRepository.loadShoppingListState(userFirebaseId) ?? {};
    if (response == null) {
      return;
    } else {
      var listItemShopping = response.mapItemShoppingList;
      var timeStart = response.startDate;
      callbackUpdateItem(
          Utilities.formatDateTimeFromSpoonacular(timeStart ?? 0),
          listItemShopping,
          responseState);
    }
  }

  Future updateItemListShoppingOnFirebase(String itemList) async {
    final String id = firebaseAuth.getUserCredential().uid;
    user ??= await _getUserProfile(id);
    if (user == null) {
      throw FirebaseException(plugin: 'open app', message: 'open app');
    }
    final dataState = Utilities.convertDataHomeWidgetToState(itemList);
    final userFirebase = firebaseAuth.getUserCredential();
    await _saveShoppingListState(dataState, userFirebase.uid);
  }

  Future<SpoonacularAccount?> _getUserProfile(String userId) async {
    try {
      return await userProfileRepository.getSpoonacularAccount(userId);
    } catch (_) {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (!connectivityResult.contains(ConnectivityResult.none)) {
        return await secureStorageManager.readSpoonacularAccount(userId);
      }
      return null;
    }
  }

  Future<void> _saveShoppingListState(
      Map<String, Map<String, bool>> dataState, String userId) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      await userProfileRepository.saveShoppingList(dataState, userId);
    } else {
      await secureStorageManager.writeShoppingState(dataState);
    }
  }
}
