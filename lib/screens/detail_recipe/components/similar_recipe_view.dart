import 'package:base_code_template_flutter/components/richtext/app_rich_text.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/resources/gen/colors.gen.dart';
import 'package:base_code_template_flutter/utilities/utilities.dart';
import 'package:flutter/material.dart';

class SimilarRecipeView extends StatelessWidget {
  final Recipe recipe;

  const SimilarRecipeView({
    super.key,
    required this.recipe,
    required this.onGetInfoRecipe,
  });

  final VoidCallback onGetInfoRecipe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onGetInfoRecipe,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: ColorName.orange33EE6723, // Màu sắc của border
            width: 2, // Độ dày của border
          ),
          borderRadius: BorderRadius.circular(8), // Bo góc border (tuỳ chọn)
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Tooltip(
                    message: recipe.title ?? "",
                    child: Text(
                      recipe.title ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  AppRichText.richTextIconText(
                      icon: const Icon(
                        size: 15,
                        Icons.access_time_filled_sharp,
                        color: ColorName.orange33EE6723,
                      ),
                      data: recipe.readyInMinutes.toString(),
                      name: ' Ready in minutes: '),
                  AppRichText.richTextIconText(
                      data: recipe.servings.toString(), name: 'Serving: '),
                ],
              ),
            ),
            if (recipe is SpooncularRecipe)
              ElevatedButton(
                  onPressed: () {
                    final url = (recipe as SpooncularRecipe).sourceUrl;
                    if (url != null) {
                      Utilities.launchInWebView(Uri.parse(url));
                    }
                  },
                  child: const Text("Go to web"))
          ],
        ),
      ),
    );
  }
}
