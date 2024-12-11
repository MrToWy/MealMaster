import 'package:flutter/material.dart';

import '../../../common/widgets/base_scaffold.dart';
import '../../../db/ingredient.dart';
import '../../../db/meal_plan.dart';
import '../../../db/meal_plan_entry.dart';
import '../../../db/recipe.dart';
import '../../../db/recipe_ingredient.dart';
import '../../../db/recipe_step.dart';

class RecipeScreen extends StatefulWidget {
  final int id;

  const RecipeScreen({super.key, required this.id});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  Recipe getTestRecipe() {
    final Ingredient ingredient = Ingredient()
      ..name = "Milch"
      ..unit = "ml";

    final RecipeIngredient recipeIngredient = RecipeIngredient()
      ..count = 3
      ..ingredients.add(ingredient);

    final RecipeStep recipeStep = RecipeStep()
      ..description = "Schritt 1 Milch milchig machen"
      ..orderPosition = 1;

    final MealPlan mealPlan = MealPlan()
      ..startDate = DateTime.now()
      ..endDate = DateTime.now().add(Duration(days: 7));

    final MealPlanEntry mealPlanEntry = MealPlanEntry()
      ..day = DateTime.now()
      ..mealPlan.add(mealPlan);

    final Recipe recipe = Recipe()
      ..cookingDuration = 25
      ..difficulty = 2
      ..steps.add(recipeStep)
      ..mealPlanEntry.add(mealPlanEntry)
      ..ingredients.add(recipeIngredient);

    return recipe;
  }

  @override
  Widget build(BuildContext context) {
    final Recipe recipe = getTestRecipe();

    return BaseScaffold(
      title: "Rezept ${widget.id}",
      hasBackButton: true,
      child: Column(
        children: [
          Expanded(
            child: CarouselView(
              itemExtent: MediaQuery.of(context).size.width * 0.66,
              shrinkExtent: 200,
              children: List<Widget>.generate(5, (int index) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.66, // 2/3 of screen width
                  child: Center(
                    child: Text('Bild $index'),
                  ),
                );
              }),
            ),
          ),
          Text('Rezept'),
          Text('Kochdauer: ${recipe.cookingDuration} Minuten'),
          Text('Schwierigkeit: ${recipe.difficulty}'),
          Text('Zutaten:'),
          Text('Schritte:'),
        ],
      ),
    );
  }
}
