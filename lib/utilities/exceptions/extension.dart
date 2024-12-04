import 'dart:core';

import 'package:base_code_template_flutter/data/models/user/user_firebase_profile.dart';

import '../../data/models/api/responses/spooncular/recipe.dart';
import '../../data/models/queries/queries.dart';
import '../../data/models/recipe/recipe.dart';

extension ConvertQueries on Queries {
  Map<String, dynamic> getMap() {
    final Map<String, dynamic> queryMap = {};
    if (cuisine != null && cuisine != Cuisine.none) {
      queryMap['cuisine'] = cuisine.toString().split('.').last;
    }
    if (diet?.isNotEmpty ?? false) {
      queryMap['diet'] =
          diet?.map((d) => d.toString().split('.').last).join('|');
    }
    if (intolerances != null && (intolerances?.isNotEmpty ?? false)) {
      queryMap['intolerances'] =
          intolerances?.map((i) => i.toString().split('.').last).join(',');
    }
    if (type != null && (type?.isNotEmpty ?? false)) {
      queryMap['type'] =
          type?.map((t) => t.toString().split('.').last).join(',');
    }
    return queryMap;
  }
}

extension TagRecipe on Recipe {
  List<RecipeTagType> getTag() {
    List<RecipeTagType> tags = [];
    if (cheap ?? false) {
      tags.add(RecipeTagType.cheap);
    }
    if (dairyFree != null && (dairyFree ?? false)) {
      tags.add(RecipeTagType.dairFree);
    }
    if (glutenFree != null && (glutenFree ?? false)) {
      tags.add(RecipeTagType.glutenFree);
    }
    if (lowFodmap != null && (lowFodmap ?? false)) {
      tags.add(RecipeTagType.lowFodmap);
    }
    if (sustainable != null && (sustainable ?? false)) {
      tags.add(RecipeTagType.sustainable);
    }
    if (vegan != null && (vegan ?? false)) {
      tags.add(RecipeTagType.vegan);
    }
    if (vegetarian != null && (vegetarian ?? false)) {
      tags.add(RecipeTagType.vegetarian);
    }
    if (veryHealthy != null && (veryHealthy ?? false)) {
      tags.add(RecipeTagType.veryHealthy);
    }
    if (ketogenic != null && (ketogenic ?? false)) {
      tags.add(RecipeTagType.ketogenic);
    }
    if (whole30 != null && (whole30 ?? false)) {
      tags.add(RecipeTagType.whole30);
    }
    return tags;
  }
}

extension Compare on UserFirebaseProfile {
  bool checkUpdate(UserFirebaseProfile other) {
    if (id != other.id) return true;
    if (name != other.name) return true;
    if (address != other.address) return true;
    if (introduce != other.introduce) return true;
    return false;
  }
}

extension ListExtensions<T> on List<T> {
  List<R> mapIndexed<R>(R Function(int index, T element) f) {
    List<R> result = [];
    for (int i = 0; i < length; i++) {
      result.add(f(i, this[i]));
    }
    return result;
  }
}
