import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mealmaster/db/meal_plan_entry.dart';
import 'package:mealmaster/features/home/presentation/widgets/date_list_tile.dart';
import 'package:mealmaster/features/home/presentation/widgets/no_meal_plan_screen.dart';
import 'package:mealmaster/features/home/presentation/widgets/recipe_list_tile.dart';
import 'package:mealmaster/features/meal_plan/data/meal_plan_repository.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
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
    log("calling initialized list");
    _initializeCombinedList();
  }

  Future<void> _initializeCombinedList() async {
    await initializeDateFormatting('de_DE', null);
    log("Ordering recipes by day");
    var combinedList = await orderRecipesByDay();

    setState(() {
      _combinedList = combinedList;

      isInitialized = true;
    });
  }

  void onReorder(int oldIndex, int newIndex) async {
    log("oldIndex: $oldIndex, newIndex: $newIndex");
    log("CombinedList before reordering: $_combinedList");
    if (newIndex == 0) return;
    if (oldIndex != newIndex) {
      final item = _combinedList.removeAt(oldIndex);
      if (newIndex > oldIndex) {
        newIndex--;
      }
      _combinedList.insert(newIndex, item);

      DateTime? newDay;
      int i = newIndex;

      while (i >= 0) {
        var entry = _combinedList[i];
        if (entry is DateTime) {
          newDay = entry;
          break;
        }
        i--;
      }

      if (newDay != null && item is MealPlanEntry) {
        MealPlanRepository().updateMealPlanEntryDay(item, newDay);
      }
    }

    log("CombinedList after reordering: $_combinedList");

    setState(() {});
  }

  Future<List> orderRecipesByDay() async {
    List combinedList = [];

    final mealPlanRepository = MealPlanRepository();
    try {
      List<MealPlanEntry> mealPlanEntries =
          await mealPlanRepository.getMealPlanEntries();
      DateTime? lastDateTime;
      log("Going in loop");
      for (var mealPlanEntry in mealPlanEntries) {
        if (combinedList.isEmpty) {
          combinedList.add(DateTime.now());
          lastDateTime = DateTime.now();
        }
        log("LastDate: ${lastDateTime?.weekday} currentDate: ${mealPlanEntry.day?.weekday}");
        if (lastDateTime != null &&
            lastDateTime.weekday == mealPlanEntry.day!.weekday) {
          //combinedList.add(mealPlanEntry.day);
          combinedList.add(mealPlanEntry);
        } else {
          lastDateTime = lastDateTime?.add(Duration(days: 1));
          combinedList.add(lastDateTime);
          if (lastDateTime != null &&
              lastDateTime.weekday == mealPlanEntry.day!.weekday) {
            combinedList.add(mealPlanEntry);
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
      log("initializing _combinedList");
      isInitialized = true;
    }

    if (!hasMealPlan || _combinedList.isEmpty) {
      return NoMealPlanScreen();
    }
    int key = 0;
    return ReorderableListView(
      onReorder: onReorder,
      buildDefaultDragHandles: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _combinedList.asMap().entries.map((entry) {
        key += 1;
        int index = entry.key;
        var item = entry.value;
        if (item is DateTime) {
          return DateListTile(
            key: ValueKey(key),
            day: item,
            index: index,
          );
        } else if (item is MealPlanEntry) {
          final recipe = item.recipe.value;

          return RecipeListTile(
            key: ValueKey(key),
            recipe: recipe,
            index: index,
          );
        } else {
          return const SizedBox.shrink();
        }
      }).toList(),
    );
  }
}
