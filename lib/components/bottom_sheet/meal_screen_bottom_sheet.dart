import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MealScreenBottomSheet extends StatelessWidget {
  final VoidCallback onTapBrowse;
  final VoidCallback onAddSaveRecipe;
  final VoidCallback onTapCreateRecipe;

  const MealScreenBottomSheet({
    super.key,
    required this.onTapBrowse,
    required this.onAddSaveRecipe,
    required this.onTapCreateRecipe,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          onTap: onTapBrowse,
          leading: const Icon(Icons.web_asset),
          title: Text(
              AppLocalizations.of(context)?.browse_recipe ?? "Browse Recipes"),
        ),
        ListTile(
          onTap: onAddSaveRecipe,
          leading: const Icon(Icons.favorite_border),
          title: Text(
              AppLocalizations.of(context)?.add_recipe ?? "Add Saved Recipe"),
        ),
        ListTile(
          onTap: onTapCreateRecipe,
          leading: const Icon(Icons.edit),
          title: Text(AppLocalizations.of(context)?.create_new ??
              "Create Personal Recipe"),
        ),
      ],
    );
  }
}
