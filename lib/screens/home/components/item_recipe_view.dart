import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ItemRecipeView extends StatelessWidget {
  final Recipe recipe;

  const ItemRecipeView({
    super.key,
    required this.recipe,
    required this.onGetInfoRecipe,
  });

  final VoidCallback onGetInfoRecipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: GestureDetector(
        onTap: onGetInfoRecipe,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  child: Hero(
                    tag: 'image_transition_detail_recipe',
                    transitionOnUserGestures: true,
                    child: CachedNetworkImage(
                      imageUrl: recipe.image ?? "",
                      fit: BoxFit.cover,
                      width: 200,
                      height: 120,
                    ),
                  )),
            ),
            SizedBox(
              width: 180,
              child: Text(recipe.title ?? "Food",
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleSmallBold),
            ),
          ],
        ),
      ),
    );
  }
}
