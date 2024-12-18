import 'package:flutter/material.dart';

import '../../../common/widgets/base_scaffold.dart';
import '../../../db/recipe.dart';
import '../../home/presentation/widgets/difficulty_indicator.dart';
import '../data/recipe_repository.dart';

class RecipeScreen extends StatefulWidget {
  final int id;

  const RecipeScreen({super.key, required this.id});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  List<Recipe> recipes = [];
  Recipe currentRecipe = Recipe();

  @override
  initState() {
    getRecipes();
    super.initState();
  }

  getRecipes() async {
    final recipes = await RecipeRepository().getRecipes();
    final recipe = await RecipeRepository().getRecipeById(widget.id);
    setState(() {
      this.recipes = recipes;
      currentRecipe = recipe;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return BaseScaffold(
      title: "${currentRecipe.title}",
      hasBackButton: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            Text("DAY", style: theme.displaySmall),
            SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height * 2 / 3,
              child: PageView.builder(
                controller: PageController(
                  viewportFraction: 0.8,
                  initialPage: 0, // TODO set to current recipe index
                ),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  Recipe recipe = recipes[index];

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
                                    difficulty: 2,
                                    // TODO set to recipe difficulty
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
