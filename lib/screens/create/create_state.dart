import 'dart:io';

import 'package:base_code_template_flutter/data/models/api/responses/spooncular/recipe.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_state.freezed.dart';

@freezed
class CreateState with _$CreateState {
  const factory CreateState({
    @Default(null) Recipe? recipe,
    @Default(false) bool createRecipe,
    @Default([]) List<Ingredient>? listIngredient,
    @Default([]) List<Ingredient>? listIngredientComplete,
    @Default(false) bool isUpload,
    @Default(null) File? imageData,
  }) = _CreateState;

  const CreateState._();
}
