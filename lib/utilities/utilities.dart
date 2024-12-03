import 'package:base_code_template_flutter/components/chart/pie_chart.dart';
import 'package:base_code_template_flutter/data/models/api/responses/nutrition/nutrients.dart';
import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe.dart';
import 'package:base_code_template_flutter/data/models/api/responses/user_comment/recipe_comment.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/data/models/user/user_firebase_profile.dart';
import 'package:base_code_template_flutter/utilities/constants/firebae_recipe_field_name.dart';
import 'package:base_code_template_flutter/utilities/exceptions/email_exception.dart';
import 'package:base_code_template_flutter/utilities/exceptions/password_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../resources/gen/assets.gen.dart';
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

  static String firebaseStorageRefRootRecipe() => "create/recipe/data";

  static List<RecipeTagType> getTagsRecipe(Recipe? recipe) {
    if (recipe == null) return [];
    List<RecipeTagType> tags = [];
    if (recipe.cheap != null && (recipe.cheap ?? false)) {
      tags.add(RecipeTagType.cheap);
    }
    if (recipe.dairyFree != null && (recipe.dairyFree ?? false)) {
      tags.add(RecipeTagType.dairFree);
    }
    if (recipe.glutenFree != null && (recipe.glutenFree ?? false)) {
      tags.add(RecipeTagType.glutenFree);
    }
    if (recipe.lowFodmap != null && (recipe.lowFodmap ?? false)) {
      tags.add(RecipeTagType.lowFodmap);
    }
    if (recipe.sustainable != null && (recipe.sustainable ?? false)) {
      tags.add(RecipeTagType.sustainable);
    }
    if (recipe.vegan != null && (recipe.vegan ?? false)) {
      tags.add(RecipeTagType.vegan);
    }
    if (recipe.vegetarian != null && (recipe.vegetarian ?? false)) {
      tags.add(RecipeTagType.vegetarian);
    }
    if (recipe.veryHealthy != null && (recipe.veryHealthy ?? false)) {
      tags.add(RecipeTagType.veryHealthy);
    }
    if (recipe.ketogenic != null && (recipe.ketogenic ?? false)) {
      tags.add(RecipeTagType.ketogenic);
    }
    if (recipe.whole30 != null && (recipe.whole30 ?? false)) {
      tags.add(RecipeTagType.whole30);
    }
    return tags;
  }

  static Map<String, dynamic> getIngredientsToFirebase(
      List<Ingredient> ingredient) {
    Map<String, dynamic> result = {};
    for (var i in ingredient) {
      result[i.id.toString()] = i.toJson();
    }
    return result;
  }

  static Map<String, dynamic> getUserPeopleLikeToFirebse(
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
        Utilities.getUserPeopleLikeToFirebse(recipe.peopleLike);
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
}
