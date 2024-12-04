// import 'package:base_code_template_flutter/components/search_recipe/search_recipe_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import '../../data/models/recipe/recipe.dart';
//
// class SearchRecipeContainer extends ConsumerWidget {
//   const SearchRecipeContainer({
//     super.key,
//     required this.onSelect,
//   });
//   final Function(Recipe recipe) onSelect;
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     TextEditingController searchController = TextEditingController();
//     final viewModel = ref.read(searchRecipeProvider.notifier);
//     final state = ref.watch(searchRecipeProvider);
//     final filteredRecipes = state.listRecipe;
//     return Column(
//       children: [
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: searchController,
//           decoration: InputDecoration(
//             labelText: AppLocalizations.of(context)?.t_search_recipe ??
//                 "Search for recipes",
//             border: const OutlineInputBorder(),
//             suffixIcon: IconButton(
//               onPressed: () async {
//                 await viewModel.searchRecipe(searchController.text);
//               },
//               icon: const Icon(Icons.search),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         if (filteredRecipes != null && filteredRecipes.isNotEmpty)
//           SizedBox(
//             height: 100,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: filteredRecipes.length,
//               itemBuilder: (context, index) {
//                 final recipe = filteredRecipes[index];
//                 return ListTile(
//                   title: Text(recipe.title ?? "No name"),
//                   subtitle: Text(recipe.summary ?? ""),
//                   onTap: () {
//                     onSelect(recipe);
//                     searchController.text = recipe.title ?? searchController.text;
//                   },
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
// }
import 'package:base_code_template_flutter/components/dialog/create_search_recipe_dialog.dart';
import 'package:base_code_template_flutter/components/search_recipe/search_recipe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/recipe/recipe.dart';

class SearchRecipeContainer extends ConsumerWidget {
  const SearchRecipeContainer({
    super.key,
    required this.onSelect,
  });

  final Function(List<Recipe>? recipes, int timeOfDate) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(searchRecipeProvider.notifier);
    final state = ref.watch(searchRecipeProvider);
    final filteredRecipes = state.listRecipe;
    final filteredSelectRecipes = state.selectRecipe;
    return CreateSearchRecipeDialog(
      dateTime: DateTime.now(),
      listRecipes: filteredRecipes,
      onSelect: (value) {
        viewModel.updateListSelectRecipe(value);
      },
      searchRecipe: (text) async {
        await viewModel.searchRecipe(text);
      },
      listSelectRecipes: filteredSelectRecipes,
      onSubmit: (timeOfDate) async {
        final listSearch = state.selectRecipe;
        viewModel.clear();
        await onSelect(listSearch, timeOfDate);
      },
    );
  }
}
