import 'dart:convert';

import 'package:base_code_template_flutter/components/chart/pie_chart.dart';
import 'package:base_code_template_flutter/data/models/api/responses/nutrition/nutrients.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe.dart';
import 'package:base_code_template_flutter/data/models/api/responses/user_comment/recipe_comment.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/data/models/shopping_list/shopping_list.dart';
import 'package:base_code_template_flutter/data/models/user/user_firebase_profile.dart';
import 'package:base_code_template_flutter/utilities/constants/firebae_recipe_field_name.dart';
import 'package:base_code_template_flutter/utilities/exceptions/email_exception.dart';
import 'package:base_code_template_flutter/utilities/exceptions/password_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../resources/gen/assets.gen.dart';
import 'constants/firebase_user_profile_field_name.dart';
import 'constants/text_constants.dart';

class Utilities {
  Utilities._();

  static String getIconPath(
    String iconStatus,
    BuildContext context,
  ) {
    switch (iconStatus) {
      case TextConstants.like:
        return Assets.icons.like.path;
      case TextConstants.love:
        return Assets.icons.loverFavorite.path;
      case TextConstants.favorite:
        return Assets.icons.loverFavorite.path;
      case TextConstants.haha:
        return Assets.icons.haha.path;
      case TextConstants.wow:
        return Assets.icons.wow.path;
      case TextConstants.sad:
        return Assets.icons.sad.path;
      case TextConstants.angry:
        return Assets.icons.angry.path;
      default:
        return '';
    }
  }

  static bool checkEmail(String? email) {
    if (email == null || email.isEmpty || !email.contains('@')) {
      throw EmailException(error: "email_invalid");
    } else {
      return true;
    }
  }

  static bool checkPassword(String? password) {
    if (password == null || password.isEmpty) {
      String error = "password_invalid";
      throw PasswordException(error: error);
    } else {
      return true;
    }
  }

  static Future<void> launchInWebView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  static String firebaseStorageRefImage(String id) =>
      "create/recipe/data/$id.png";

  static String firebaseStorageRefAvatar(String id) => "user/$id/avatar.png";

  static String firebaseStorageRefRootRecipe() => "create/recipe/data";

  static Map<String, dynamic> getIngredientsToFirebase(
      List<Ingredient> ingredient) {
    Map<String, dynamic> result = {};
    for (var i in ingredient) {
      result[i.id.toString()] = i.toJson();
    }
    return result;
  }

  static Map<String, dynamic> getUserPeopleLikeToFirebase(
      List<UserFirebaseProfile> peopleLike) {
    Map<String, dynamic> result = {};
    for (var i in peopleLike) {
      result[i.id] = i.toJson();
    }
    return result;
  }

  static List<dynamic>? converterPeopleLikeProfileFormFirebase(
      Map<String, dynamic> peopleLike) {
    if (peopleLike.isEmpty) {
      return null;
    }
    List<dynamic> likers = peopleLike.values.toList();

    return likers;
  }

  static List<dynamic>? convertListCommentFormFirebase(
      Map<String, dynamic> listComment) {
    if (listComment.isEmpty) {
      return null;
    }
    List<dynamic> comments = listComment.values.toList();
    return comments;
  }

  static Map<String, dynamic> getListCommentToFirebase(
      List<RecipeComment> comments) {
    Map<String, dynamic> result = {};
    for (int i = 0; i < comments.length; i++) {
      result['comment_$i'] = comments[i].toJson();
      result['comment_$i']['user'] = comments[i].user.toJson();
    }
    return result;
  }

  static List<dynamic>? converterListIngredientsFormFirebase(
      Map<String, dynamic> listIngredient) {
    if (listIngredient.isEmpty) {
      return null;
    }
    List<dynamic> ingredientsList = listIngredient.values.toList();

    return ingredientsList;
  }

  static FirebaseRecipe converterRecipeFromFirebase(Map<String, dynamic> json) {
    json[FirebaseRecipeFieldName.extendedIngredients] =
        converterListIngredientsFormFirebase(
            json[FirebaseRecipeFieldName.extendedIngredients] ?? {});
    json[FirebaseRecipeFieldName.peopleLike] =
        converterPeopleLikeProfileFormFirebase(
            json[FirebaseRecipeFieldName.peopleLike]);
    json[FirebaseRecipeFieldName.listComment] = convertListCommentFormFirebase(
        json[FirebaseRecipeFieldName.listComment]);
    return FirebaseRecipe.fromJson(json);
  }

  static Map<String, dynamic> converterRecipeToFirebase(FirebaseRecipe recipe) {
    final json = recipe.toJson();
    json[FirebaseRecipeFieldName.extendedIngredients] =
        Utilities.getIngredientsToFirebase(recipe.extendedIngredients);
    json[FirebaseRecipeFieldName.peopleLike] =
        Utilities.getUserPeopleLikeToFirebase(recipe.peopleLike);
    json[FirebaseRecipeFieldName.listComment] =
        Utilities.getListCommentToFirebase(recipe.listComment);
    json[FirebaseRecipeFieldName.user] = recipe.user?.toJson();
    return json;
  }

  static String formatDateTime(DateTime time) {
    final now = DateTime.now();
    final duration = now.difference(time);
    int weeks = duration.inDays ~/ 7;
    int days = duration.inDays;
    if (days == 0 && duration.inHours <= 0) {
      if (duration.inSeconds < 3) return 'now';
      return "${duration.inMinutes}s";
    }
    if (duration.inHours > 0 && duration.inHours < 24) {
      return "${duration.inHours} giờ";
    }
    if (days > 0 && days < 7) {
      return '$days ngày';
    }
    if (weeks > 0 && weeks < 52) {
      return '$weeks tuần ';
    }
    return DateFormat('dd/MM/yyyy').format(time);
  }

  static List<ChartSegment> convertToListDataChart(
      Caloricbreakdown? nutrition) {
    if (nutrition == null) return [];
    return <ChartSegment>[
      if (nutrition.percentProtein != null)
        ChartSegment(
            amount: nutrition.percentProtein ?? 0,
            label: 'Protein',
            color: const Color.fromARGB(255, 255, 153, 153)),
      if (nutrition.percentFat != null)
        ChartSegment(
            amount: nutrition.percentFat ?? 0,
            label: 'Fat',
            color: const Color.fromARGB(255, 255, 102, 102)),
      if (nutrition.percentCarbs != null)
        ChartSegment(
            amount: nutrition.percentCarbs ?? 0,
            label: 'Carb',
            color: const Color.fromARGB(255, 153, 102, 51)),
    ];
  }

  static String formatDateTimeSpoonacular(DateTime date) {
    return date.toIso8601String().split('T').first;
  }

  static String formatDateTimeFromSpoonacular(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date * 1000);
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  static String formatEnumQueriesName(String text) {
    String name = text.split('.').last;
    String formattedName = name
        .splitMapJoin(
          RegExp('([A-Z])'),
          onMatch: (m) => ' ${m.group(0)}',
          onNonMatch: (n) => n,
        )
        .trim();
    if (formattedName.isNotEmpty) {
      formattedName =
          formattedName[0].toUpperCase() + formattedName.substring(1);
    }
    return formattedName;
  }

  static Map<String, dynamic> converterShoppingListForFirebase(
      Map<String, Map<String, bool>> shoppingList) {
    return {FirebaseUserProfileFieldName.shoppingList: shoppingList};
  }

  static String converterDataForHomeWidget(
    Map<String, List<ItemAisles>> shoppingList,
    Map<String, Map<String, bool>> stateList,
  ) {
    Map<String, dynamic> jsonMap = shoppingList.map((key, value) {
      return MapEntry(
          key,
          value.map((item) {
            Map<String, dynamic> itemJson = item.toJson();
            itemJson[TextConstants.isChecked] =
                stateList[key]?[item.id.toString()] ?? false;
            return itemJson;
          }).toList());
    });
    return jsonEncode(jsonMap);
  }

  static String updateWhenCheckItemHomeWidget(
      String json, String item, int id) {
    try {
      Map<String, dynamic> data = jsonDecode(json);
      var listItem = data[item] ?? [];
      for (var i in listItem) {
        if (i[TextConstants.id] == id) {
          i[TextConstants.isChecked] = !i[TextConstants.isChecked];
        }
      }
      return jsonEncode(data);
    } catch (e) {
      throw Exception("Can't update data home widget!");
    }
  }

  static Map<String, Map<String, bool>> convertDataHomeWidgetToState(
      String json) {
    Map<String, dynamic> data = jsonDecode(json);
    Map<String, Map<String, bool>> result = {};
    data.forEach((key, item) {
      if (item is List<dynamic>) {
        Map<String, bool> innerMap = {};
        for (var i in item) {
          var value = i[TextConstants.isChecked];
          if (value is bool) {
            innerMap[i[TextConstants.id].toString()] = value;
          }
        }
        result[key] = innerMap;
      }
    });
    return result;
  }
}
