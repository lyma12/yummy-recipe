import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/data/models/meal_plan/meal_plan.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:base_code_template_flutter/resources/gen/assets.gen.dart';
import 'package:base_code_template_flutter/utilities/exceptions/extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../router/detail_recipe_route.dart';

class ItemMealPlanDay extends StatelessWidget {
  final ItemMeal data;

  const ItemMealPlanDay({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final value = data.value;
    final backGround = data.color;
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: Card(
        color: backGround,
        child: SizedBox(
          height: 100,
          child: GestureDetector(
            onTap: () async {
              final type = data.getType();
              switch (type) {
                case ItemMealType.recipe:
                  final int recipeId = int.parse(data.value?.id ?? "0");
                  final recipe = Recipe.spoonacular(id: recipeId);
                  await AutoRouter.of(context)
                      .push(DetailRecipeRoute(recipe: recipe).route());
                  break;
                case ItemMealType.ingredients:
                  final id = data.value?.id ?? "";
                  final recipe = Recipe.firebase(id: id);
                  await AutoRouter.of(context)
                      .push(DetailRecipeRoute(recipe: recipe).route());
                default:
                  break;
              }
            },
            child: Row(
              children: [
                if (value?.image != null)
                  CachedNetworkImage(
                    imageUrl: value?.image ?? "",
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100,
                    errorWidget: (context, _, error) =>
                        Assets.images.signinBackGround.image(
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                Expanded(
                    child: ListTile(
                  title: Text(
                    value?.title ?? "item",
                    style: AppTextStyles.titleSmallBold,
                  ),
                  trailing: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.dehaze)),
                  subtitle: Text("Serving: ${value?.servings}"),
                ))
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
