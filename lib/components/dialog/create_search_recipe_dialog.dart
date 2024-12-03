import 'package:base_code_template_flutter/components/dialog/base_dialog.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:base_code_template_flutter/utilities/utilities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/models/recipe/recipe.dart';

class CreateSearchRecipeDialog extends BaseDialog {
  const CreateSearchRecipeDialog({
    super.key,
    super.onClosed,
    required this.dateTime,
    required this.listRecipes,
    required this.searchRecipe,
    required this.onSelect,
    required this.listSelectRecipes,
    required this.onSubmit,
    super.height,
  }) : super(title: "Create Meal Plan");
  final DateTime dateTime;
  final List<Recipe>? listRecipes;
  final Function(String text) searchRecipe;
  final Function(Recipe recipe) onSelect;
  final List<Recipe>? listSelectRecipes;
  final Function(int timeOfDate) onSubmit;

  @override
  Widget? buildContext(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    final filteredRecipes = listRecipes;
    final filteredSelectRecipes = listSelectRecipes;
    int? selectTimeOfDay = 1;
    final List<int> timeOfDay = [1, 2, 3];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      //child: Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              Utilities.formatDateTimeFromSpoonacular(
                  dateTime.microsecondsSinceEpoch ~/ 1000000),
              style: AppTextStyles.titleMediumBold,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.t_search_recipe ??
                    "Search for recipes",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () async {
                    if (searchController.text.isEmpty) return;
                    await searchRecipe(searchController.text);
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (filteredRecipes != null && filteredRecipes.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = filteredRecipes[index];
                    return ListTile(
                      leading: CachedNetworkImage(
                          height: 40, width: 40, imageUrl: recipe.image ?? ""),
                      title: Text(
                        recipe.title ?? "No name",
                        style: AppTextStyles.titleSmallBold,
                      ),
                      onTap: () {
                        onSelect(recipe);
                      },
                    );
                  },
                ),
              ),
            Text(
              "List recipe select",
              style: AppTextStyles.titleSmallBold,
            ),
            if (filteredSelectRecipes != null &&
                filteredSelectRecipes.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredSelectRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = filteredSelectRecipes[index];
                    return ListTile(
                      leading: CachedNetworkImage(
                          height: 40, width: 40, imageUrl: recipe.image ?? ""),
                      title: Text(
                        recipe.title ?? "No name",
                        style: AppTextStyles.titleSmall,
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.t_time_of_day ??
                    "Time of day",
                border: const OutlineInputBorder(),
              ),
              value: selectTimeOfDay,
              onChanged: (int? newValue) {
                selectTimeOfDay = newValue;
              },
              items: timeOfDay
                  .map(
                    (item) => DropdownMenuItem<int>(
                      value: item,
                      child: Text(
                          AppLocalizations.of(context)?.time_of_day(item) ??
                              "Other"),
                    ),
                  )
                  .toList(),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectTimeOfDay != null &&
                    listSelectRecipes != null &&
                    listSelectRecipes!.isNotEmpty) {
                  await onSubmit(selectTimeOfDay ?? 1);
                }
              },
              child: Text(AppLocalizations.of(context)?.create_meal_plan ??
                  "Create meal plan"),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
