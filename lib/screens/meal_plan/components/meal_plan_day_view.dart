import 'package:base_code_template_flutter/data/models/meal_plan/meal_plan.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:flutter/material.dart';

import 'item_meal_plan_day.dart';

class MealPlanDayView extends StatelessWidget {
  final MealPlanDay? mealPlan;
  final Function(int id) onDismissItem;

  const MealPlanDayView({
    super.key,
    required this.mealPlan,
    required this.onDismissItem,
  });

  @override
  Widget build(BuildContext context) {
    final Map<int, List<ItemMeal>> groupedItems = {};
    final items = mealPlan?.items ?? [];

    for (var item in items) {
      groupedItems.putIfAbsent(item.slot ?? 1, () => []).add(item);
    }

    final List<int> positionsOrder = [
      1,
      2,
      3
    ]; // 1: bữa sáng, 2: bữa trưa, 3: bữa tối

    return SingleChildScrollView(
      child: Column(
        children: [
          for (var position in positionsOrder)
            _buildMealSection(position, groupedItems[position]),
        ],
      ),
    );
  }

  Widget _buildMealSection(int position, List<ItemMeal>? itemsForPosition) {
    if (itemsForPosition == null || itemsForPosition.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            position == 1
                ? 'Breakfast'
                : position == 2
                    ? 'Lunch'
                    : 'Dinner',
            style: AppTextStyles.titleMediumBold,
          ),
        ),
        ...itemsForPosition.map((item) {
          return Dismissible(
            key: Key(item.id.toString()),
            background: Container(
              color: Colors.red,
              child: const Icon(Icons.delete),
            ),
            onDismissed: (direction) async {
              final id = item.id;
              if (id == null) return;
              await onDismissItem(id);
            },
            child: ItemMealPlanDay(data: item),
          );
        }),
      ],
    );
  }
}
