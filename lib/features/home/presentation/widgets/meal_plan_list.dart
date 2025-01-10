import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mealmaster/db/meal_plan_entry.dart';
import 'package:mealmaster/db/recipe.dart';
import 'package:mealmaster/features/home/presentation/widgets/date_list_tile.dart';
import 'package:mealmaster/features/home/presentation/widgets/no_meal_plan_screen.dart';
import 'package:mealmaster/features/home/presentation/widgets/recipe_list_tile.dart';
import 'package:mealmaster/features/meal_plan/data/meal_plan_repository.dart';
import 'package:provider/provider.dart';

import '../../../meal_plan/presentation/controller/meal_plan_provider.dart';

class MealPlanList extends StatefulWidget {
  const MealPlanList({
    super.key,
  });

  @override
  State<MealPlanList> createState() => _MealPlanListState();
}

class _MealPlanListState extends State<MealPlanList> {
  late List _combinedList;
  bool hasMealPlan = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeCombinedList();
  }

  Future<void> _initializeCombinedList() async {
    setState(() {
      isLoading = true;
    });

    await initializeDateFormatting('de_DE', null);
    var combinedList = await orderRecipesByDay();

    setState(() {
      _combinedList = combinedList;
      isLoading = false;
    });
  }

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      // TODO: Save the new order in the database
    });
  }

  List<String> getNextSevenDays() {
    final now = DateTime.now();
    final DateFormat formatter = DateFormat('EE', 'de_DE');
    return List.generate(7,
        (i) => formatter.format(now.add(Duration(days: i + 1))).toUpperCase());
  }

  Future<List> orderRecipesByDay() async {
    List<String> nextSevenDays = getNextSevenDays();
    List combinedList = [];

    final mealPlanRepository = MealPlanRepository();
    try {
      List<MealPlanEntry> mealPlanEntries =
          await mealPlanRepository.getMealPlanEntries();
      for (var dayString in nextSevenDays) {
        combinedList.add(dayString);

        for (var mealPlanEntry in mealPlanEntries) {
          if (mealPlanEntry.day != null) {
            final entryDay = DateFormat('EE', 'de_DE')
                .format(mealPlanEntry.day!)
                .toUpperCase();

            if (entryDay == dayString) {
              await mealPlanEntry.recipe.load();
              final recipe = mealPlanEntry.recipe.value;

              if (recipe != null) {
                combinedList.add(recipe);
              }
            }
          }
        }
      }
    } catch (e) {
      if (e.toString().contains('No meal plan found')) {
        setState(() {
          hasMealPlan = false;
        });
        return [];
      }
    }
    setState(() {
      hasMealPlan = true;
    });
    return combinedList;
  }

  @override
  Widget build(BuildContext context) {
    if (!hasMealPlan) {
      return NoMealPlanScreen();
    }

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // When provider changes, recreate the Future
    final _ = context.watch<MealPlanProvider>();
    _initializeCombinedList();

    return ReorderableListView(
      onReorder: onReorder,
      buildDefaultDragHandles: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _combinedList.asMap().entries.map((entry) {
        int index = entry.key;
        var item = entry.value;
        if (item is String) {
          return DateListTile(
            key: ValueKey(item),
            day: item,
            index: index,
          );
        } else if (item is Recipe) {
          return RecipeListTile(
            key: ValueKey(item.id),
            recipe: item,
            index: index,
          );
        } else {
          return const SizedBox.shrink();
        }
      }).toList(),
    );
  }
}
