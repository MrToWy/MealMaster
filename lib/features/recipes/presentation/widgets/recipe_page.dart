import 'package:flutter/material.dart';

import '../../../../db/recipe.dart';
import '../../../../db/recipe_ingredient.dart';
import '../../../home/presentation/widgets/difficulty_indicator.dart';

class RecipePage extends StatelessWidget {
  final Recipe recipe;

  const RecipePage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(
                  '${recipe.cookingDuration} min',
                  style: theme.titleMedium,
                ),
                SizedBox(width: 20),
                Text('-'),
                SizedBox(width: 20),
                DifficultyIndicator(
                  difficulty: recipe.difficulty ?? 1,
                  size: 20,
                ),
              ]),
              Text('Zutaten', style: theme.headlineMedium),
              for (RecipeIngredient ingredient in recipe.ingredients)
                SizedBox(
                    height: 20,
                    child: Text(
                        ingredient.ingredient.value?.name ?? 'Unbekannte Zutat',
                        style: theme.bodyMedium)),
              SizedBox(height: 20),
              Text('Schritte:', style: theme.headlineMedium),
              Expanded(
                child: ListView.builder(
                  itemCount: recipe.steps.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        '${index + 1}. ${recipe.steps.elementAt(index).description}',
                        style: theme.bodyMedium,
                        softWrap: true,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
