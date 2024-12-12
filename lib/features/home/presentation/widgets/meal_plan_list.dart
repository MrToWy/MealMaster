import 'package:flutter/material.dart';
import 'package:mealmaster/features/home/presentation/widgets/date_list_tile.dart';
import 'package:mealmaster/features/home/presentation/widgets/recipe_list_tile.dart';
import 'package:mealmaster/features/recipes/domain/recipe.dart';

class MealPlanList extends StatefulWidget {
  final List<Recipe> recipes;
  const MealPlanList({
    super.key,
    required this.recipes,
  });

  @override
  State<MealPlanList> createState() => _MealPlanListState();
}

class _MealPlanListState extends State<MealPlanList> {
  final List<String> _days = ['MO', 'DI', 'MI', 'DO', 'FR', 'SA', 'SO'];

  void onReorder(int oldIndex, int newIndex) {
    //TODO change order and save in db
  }

  @override
  Widget build(BuildContext context) {
    List combinedList = [];
    for (int i = 0; i < widget.recipes.length; i++) {
      combinedList.add(_days[i % _days.length]);
      combinedList.add(widget.recipes[i]);
    }
    return ReorderableListView(
      onReorder: onReorder,
      buildDefaultDragHandles: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: combinedList.asMap().entries.map((entry) {
        int index = entry.key;
        var item = entry.value;

        if (item is String) {
          return DateListTile(
              key: ValueKey('date_$index'), day: item, index: index);
        } else if (item is Recipe) {
          return RecipeListTile(
              key: ValueKey('recipe_${item.id}'), recipe: item, index: index);
        } else {
          return const SizedBox.shrink();
        }
      }).toList(),
    );
  }
}
