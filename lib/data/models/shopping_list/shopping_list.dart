import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_list.freezed.dart';
part 'shopping_list.g.dart';

@freezed
class ShoppingList with _$ShoppingList {
  const factory ShoppingList({
    @Default([]) List<Aisles> aisles,
    double? cost,
    int? startDate,
    int? endDate,
  }) = _ShoppingList;

  factory ShoppingList.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListFromJson(json);
}

@freezed
class Aisles with _$Aisles {
  const factory Aisles({
    String? aisle,
    @Default([]) List<ItemAisles>? items,
  }) = _Aisles;

  factory Aisles.fromJson(Map<String, dynamic> json) => _$AislesFromJson(json);
}

@freezed
class ItemAislesState with _$ItemAislesState {
  const factory ItemAislesState({
    @Default(false) bool? isChecked,
    int? id,
  }) = _ItemAislesState;

  factory ItemAislesState.fromJson(Map<String, dynamic> json) =>
      _$ItemAislesStateFromJson(json);
}

@freezed
class ItemAisles with _$ItemAisles {
  const factory ItemAisles({
    String? name,
    int? id,
    @Default({}) Map<String, Measure>? measures,
    @Default(false) bool? pantryItem,
    String? aisle,
    double? cost,
    int? ingredientId,
  }) = _ItemAisles;

  factory ItemAisles.fromJson(Map<String, dynamic> json) =>
      _$ItemAislesFromJson(json);
}

@freezed
class ItemShoppingListRequest with _$ItemShoppingListRequest {
  const factory ItemShoppingListRequest({
    String? item,
    String? aisle,
    @Default(false) parse,
  }) = _ItemShoppingListRequest;

  factory ItemShoppingListRequest.fromJson(Map<String, dynamic> json) =>
      _$ItemShoppingListRequestFromJson(json);
}

extension ShoppingListExtension on ShoppingList {
  Map<String, List<ItemAisles>> get mapItemShoppingList {
    Map<String, List<ItemAisles>> result = {};
    final aisles = this.aisles;
    if (aisles.isNotEmpty) {
      for (var item in aisles) {
        final aisle = item.aisle;
        if (aisle == null) continue;
        result[aisle] = item.items ?? [];
      }
    }
    return result;
  }

  Map<String, Map<String, bool>> get state {
    Map<String, Map<String, bool>> result = {};
    final aisles = this.aisles;
    if (aisles.isNotEmpty) {
      for (var item in aisles) {
        Map<String, bool> aislesState = {};
        final aisle = item.aisle;
        if (aisle == null) continue;
        item.items?.forEach((itemAisles) {
          aislesState[itemAisles.id.toString()] = false;
        });
        result[aisle] = aislesState;
      }
    }
    return result;
  }
}
