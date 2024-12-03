import 'package:base_code_template_flutter/data/models/shopping_list/shopping_list.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_list_state.freezed.dart';

@freezed
class ShoppingListState with _$ShoppingListState {
  const factory ShoppingListState({
    @Default({}) Map<String, List<ItemAisles>> listItemShopping,
    @Default({}) Map<String, Map<String, bool>> listItemState,
    @Default(0) double cost,
    int? timeStart,
    int? timeEnd,
  }) = _ShoppingListState;

  const ShoppingListState._();
}
