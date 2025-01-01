import 'package:flutter/material.dart';
import 'package:mealmaster/features/home/presentation/widgets/meal_plan_list.dart';
import 'package:mealmaster/features/recipes/domain/recipe.dart';
import 'package:provider/provider.dart';

import 'controller/edit_mode_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Recipe> recipes;
  String user = 'Max';

  @override
  void initState() {
    super.initState();
    recipes = [
      Recipe(
          id: 1, hasAllIngredients: true, cookingDuration: 25, difficulty: 2),
      Recipe(
          id: 2, hasAllIngredients: false, cookingDuration: 15, difficulty: 1),
      Recipe(
          id: 3, hasAllIngredients: true, cookingDuration: 40, difficulty: 3),
      Recipe(
          id: 4, hasAllIngredients: false, cookingDuration: 30, difficulty: 2),
      Recipe(
          id: 5, hasAllIngredients: true, cookingDuration: 10, difficulty: 1),
      Recipe(
          id: 6, hasAllIngredients: false, cookingDuration: 50, difficulty: 3),
      Recipe(
          id: 7, hasAllIngredients: true, cookingDuration: 20, difficulty: 1),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          centerTitle: true,
          title: Text(
            'Hallo $user!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          leadingWidth: 100,
          leading: TextButton(
            onPressed: () {
              final currentMode = context.read<EditModeProvider>().inEditMode;
              context.read<EditModeProvider>().setEditMode(!currentMode);
            },
            child: Text(
              context.watch<EditModeProvider>().inEditMode
                  ? 'Fertig'
                  : 'Bearbeiten',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/new-plan');
              },
              child: Text(
                'Neuer Plan',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: MealPlanList(),
        ),
      ],
    );
  }
}
