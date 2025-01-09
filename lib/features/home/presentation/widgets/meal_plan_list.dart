import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mealmaster/db/meal_plan_entry.dart';
import 'package:mealmaster/db/recipe.dart';
import 'package:mealmaster/features/home/presentation/widgets/date_list_tile.dart';
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
  late Future<List> _combinedList;
  bool noMealPlan = true;

  @override
  void initState() {
    super.initState();
    _combinedList = _initializeCombinedList();
  }

  Future<List> _initializeCombinedList() async {
    await initializeDateFormatting('de_DE', null);
    return orderRecipesByDay(); // Fetch recipes
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
          noMealPlan = true;
        });
        return [];
      }
    }
    setState(() {
      noMealPlan = false;
    });
    return combinedList;
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    if (noMealPlan) {
      return Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
            SizedBox(height: 50.0),
            Icon(
              Icons.fastfood, // Symbol für Essen
              size: 80.0,
              color: colorTheme.primary,
            ),
            SizedBox(height: 20.0),
            Text(
              'Kein MealPlan gefunden',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Erstelle jetzt deinen ersten MealPlan!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/new-plan');
              },
              child: Text(
                'Neuer Plan',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ]));
    }
    ;

    // When provider changes, recreate the Future
    final _ = context.watch<MealPlanProvider>();
    _combinedList = _initializeCombinedList();

    return FutureBuilder<List>(
      future: _combinedList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No data available'),
          );
        } else {
          final combinedList = snapshot.data!;
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
      },
    );
  }
}
