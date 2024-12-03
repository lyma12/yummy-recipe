import 'package:base_code_template_flutter/components/images/recipe_circle_image.dart';
import 'package:base_code_template_flutter/components/richtext/app_rich_text.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:flutter/material.dart';

class ItemFavourite extends StatelessWidget {
  const ItemFavourite({super.key, required this.recipe, this.onTap});

  final Recipe recipe;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 240,
      child: Stack(
        children: [
          Positioned(
            top: 30,
            left: 10,
            child: SizedBox(
              width: 240,
              height: 200,
              child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  child: GestureDetector(
                    onTap: onTap ?? () {},
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 80, left: 16, right: 16),
                      child: Column(
                        children: [
                          Text(
                            recipe.title ?? "",
                            style: AppTextStyles.titleMediumBold,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            recipe.summary ?? "",
                            style: AppTextStyles.titleSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          AppRichText.richTextIconText(
                              data: recipe.servings.toString(),
                              name: " serving: ",
                              icon: const Icon(
                                Icons.person,
                                size: 12,
                              )),
                          AppRichText.richTextIconText(
                              data: (recipe.spoonacularScore ?? 0)
                                  .roundToDouble()
                                  .toString(),
                              name: " score: ",
                              icon: const Icon(
                                Icons.star,
                                size: 12,
                              ))
                        ],
                      ),
                    ),
                  )),
            ),
          ),
          if (recipe.image != null)
            Positioned(
              left: 40,
              child: RecipeCircleImage(
                  url: recipe.image ?? "", width: 100, height: 100),
            ),
        ],
      ),
    );
  }
}
