import 'package:flutter/material.dart';

import '../../../../db/recipe.dart';
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
              child: SingleChildScrollView(
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
                  ...recipe.ingredients.map(
                    (ingredient) => SizedBox(
                        height: 20,
                        child: Text(
                            "- ${ingredient.count?.toStringAsFixed(0)} ${ingredient.ingredient.value?.unit} ${ingredient.ingredient.value?.name ?? 'Unbekannte Zutat'}",
                            style: theme.bodyMedium)),
                  ),
                  SizedBox(height: 20),
                  Text('Schritte', style: theme.headlineMedium),
                  ...recipe.steps.map((step) => Text(
                        '${step.orderPosition}. ${step.description}',
                        style: theme.bodyMedium,
                      )),
                ],
              ))),
        ));
  }
}
