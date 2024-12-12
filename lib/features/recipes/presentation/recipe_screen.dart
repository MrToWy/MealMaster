import 'package:flutter/material.dart';

import '../../../common/widgets/base_scaffold.dart';
import '../../../db/recipe.dart';
import '../../home/presentation/widgets/difficulty_indicator.dart';

class RecipeScreen extends StatefulWidget {
  final int id;

  const RecipeScreen({super.key, required this.id});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  Recipe getTestRecipe() {
    final Recipe recipe = Recipe()
      ..cookingDuration = 25
      ..difficulty = 2;

    return recipe;
  }

  @override
  Widget build(BuildContext context) {
    final Recipe recipe = getTestRecipe();
    final recipeCount = 5;

    final theme = Theme.of(context).textTheme;

    return BaseScaffold(
      title: "Rezept ${widget.id}",
      hasBackButton: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            Text("Day", style: theme.displaySmall),
            SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height * 2 / 3,
              child: PageView.builder(
                controller: PageController(
                  viewportFraction: 0.8,
                  initialPage: widget.id,
                ),
                itemCount: recipeCount,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${recipe.cookingDuration} min',
                                    style: theme.titleMedium,
                                  ),
                                  SizedBox(width: 20),
                                  Text('-'),
                                  SizedBox(width: 20),
                                  DifficultyIndicator(
                                    difficulty: recipe.difficulty!,
                                    size: 20,
                                  ),
                                ]),
                            Text('Zutaten', style: theme.headlineMedium),
                            SizedBox(height: 20),
                            Text('Schritte:', style: theme.headlineMedium),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
