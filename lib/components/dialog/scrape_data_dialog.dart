import 'package:base_code_template_flutter/components/dialog/base_dialog.dart';
import 'package:flutter/material.dart';

import '../../data/models/recipe/recipe.dart';

class ScrapeDataDialog extends BaseDialog {
  const ScrapeDataDialog({
    super.key,
    required this.onSelect,
    required this.listRecipe,
  }) : super(title: "Select one recipe");

  final void Function(Recipe) onSelect;
  final List<Recipe> listRecipe;

  @override
  Widget? buildContext(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemBuilder: (context, index) {
          final item = listRecipe[index];
          return ListItemScrape(recipe: item, onSelect: onSelect);
        },
        itemCount: listRecipe.length,
      ),
    );
  }
}

class ListItemScrape extends StatelessWidget {
  final Recipe recipe;
  final void Function(Recipe) onSelect;

  const ListItemScrape({
    super.key,
    required this.recipe,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(recipe.title ?? "No Title Available"),
      onTap: () {
        onSelect(recipe);
      },
    );
  }
}
