import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favourite_state.freezed.dart';

@freezed
class FavouriteState with _$FavouriteState {
  const factory FavouriteState({
    @Default([]) List<Recipe> favouriteRecipes,
  }) = _FavouriteState;

  const FavouriteState._();
}
