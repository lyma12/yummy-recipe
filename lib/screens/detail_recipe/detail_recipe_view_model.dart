import 'package:base_code_template_flutter/components/base_view/base_view_model.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/data/providers/favourite_recipe_provider.dart';
import 'package:base_code_template_flutter/screens/detail_recipe/detail_recipe_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class DetailRecipeViewModel<T extends DetailRecipeState>
    extends BaseViewModel<T> {
  DetailRecipeViewModel(this.ref, this.favouriteRecipeProvider, super.state);

  final Ref ref;
  final FavouriteRecipeProvider favouriteRecipeProvider;

  Future<void> initData(Recipe recipe);

  void resetData();

  Future<void> saveRecipeInLocalStorage(Recipe recipe) async {
    await favouriteRecipeProvider.addFavouriteRecipe(recipe);
  }

  String _removeHtmlTags(String htmlString) {
    final regex = RegExp(r'<[^>]*>', multiLine: true); // Matches all HTML tags
    return htmlString.replaceAll(regex, '');
  }

  String _formatText(String text) {
    // Optional: Implement basic formatting logic here (e.g., line breaks)
    return text.replaceAll(
        '\n', '\n\n'); // Add double line breaks for readability
  }

  String prepareInstruction(String htmlString) {
    final textWithoutTags = _removeHtmlTags(htmlString);
    final formattedText = _formatText(textWithoutTags);
    return formattedText;
  }

  void returnRecipeBefore();
}
