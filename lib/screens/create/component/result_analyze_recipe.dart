import 'dart:io';

import 'package:base_code_template_flutter/components/richtext/app_rich_text.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:base_code_template_flutter/screens/detail_recipe/components/recipe_icon_view.dart';
import 'package:base_code_template_flutter/utilities/exceptions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResultAnalyzeRecipe extends StatelessWidget {
  const ResultAnalyzeRecipe(
      {super.key, required this.recipe, required this.image});

  final Recipe recipe;
  final File? image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 400,
      child: Card(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  recipe.title ?? "Your recipe",
                  style: AppTextStyles.titleLargeBold,
                ),
              ),
              if (image != null)
                Image.file(
                  width: 300,
                  height: 200,
                  image!,
                  fit: BoxFit.fill,
                ),
              _getListTags(),
              AppRichText.richTextTitleValueIcon(
                  title: AppLocalizations.of(context)?.price_per_serving,
                  value: recipe.pricePerServing,
                  iconString: " \$"),
              AppRichText.richTextTitleValueIcon(
                title: AppLocalizations.of(context)?.health_score,
                value: recipe.healthScore,
                icon: const Icon(
                  Icons.health_and_safety_outlined,
                  color: Colors.red,
                ),
              ),
              AppRichText.richTextTitleValueIcon(
                title: AppLocalizations.of(context)?.spoonacular_score,
                value: recipe.spoonacularScore,
                icon: const Icon(
                  size: 20,
                  Icons.star,
                  color: Colors.yellow,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getListTags() {
    final tags = recipe.getTag();
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
            ),
            child: RecipeIconview(type: tags[index]),
          );
        },
      ),
    );
  }
}
