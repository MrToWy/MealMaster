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

import '../../../../db/meal_plan.dart';
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
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCombinedList();
  }

  Future<void> _initializeCombinedList() async {
    await initializeDateFormatting('de_DE', null);
    var combinedList = await orderRecipesByDay();

    setState(() {
      _combinedList = combinedList;
      if (_combinedList.isNotEmpty) {
        isInitialized = true;
      }
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

  Future<List<String>> getRemainingDays() async {
    final now = DateTime.now();
    final DateFormat formatter = DateFormat('EE', 'de_DE');

    MealPlanRepository mealPlanRepository = MealPlanRepository();
    MealPlan mealPlan = await mealPlanRepository.getCurrentMealPlan();

    int remainingDays = 0;
    if (mealPlan.endDate!.isBefore(now)) {
      remainingDays = 0;
    } else {
      remainingDays = mealPlan.endDate!.difference(now).inDays + 1;
    }

    return List.generate(remainingDays,
        (i) => formatter.format(now.add(Duration(days: i))).toUpperCase());
  }

  Future<List> orderRecipesByDay() async {
    List combinedList = [];

    final mealPlanRepository = MealPlanRepository();
    try {
      List<String> remainingDays = await getRemainingDays();
      List<MealPlanEntry> mealPlanEntries =
          await mealPlanRepository.getMealPlanEntries();
      for (var dayString in remainingDays) {
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
    final mealPlanProvider = context.watch<MealPlanProvider>();

    if (!isInitialized || mealPlanProvider.version > 0) {
      _initializeCombinedList();
    }

    if (!hasMealPlan || _combinedList.isEmpty) {
      return NoMealPlanScreen();
    }

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
