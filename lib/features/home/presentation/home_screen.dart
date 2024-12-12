import 'package:flutter/material.dart';
import 'package:mealmaster/features/home/presentation/widgets/meal_plan_list.dart';
import 'package:mealmaster/features/recipes/domain/recipe.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Recipe> recipes;
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
    return Column(children: [
      Container(
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 15),
            Text(
              'Hallo Max!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
      MealPlanList(
        recipes: recipes,
      ),
    ]);
  }
}
