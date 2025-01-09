import 'package:flutter/material.dart';

import '../../../common/widgets/base_scaffold.dart';
import '../../../db/recipe.dart';
import '../data/recipe_repository.dart';
import 'widgets/recipe_page.dart';

class RecipeScreen extends StatefulWidget {
  final int id;

  const RecipeScreen({super.key, required this.id});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  List<Recipe> recipes = [];
  late PageController _pageController;
  Recipe currentRecipe = Recipe();

  @override
  initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    getRecipes();
  }

  getRecipes() async {
    final recipes = await RecipeRepository().getRecipes();
    final recipe = await RecipeRepository().getRecipeById(widget.id);
    int initialIndex = recipes.indexWhere((r) => r.id == recipe.id);
    setState(() {
      this.recipes = recipes;
      currentRecipe = recipe;
      if (initialIndex != -1) {
        // Sicherstellen, dass die Methode nach dem Frame-Aufbau aufgerufen wird
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            _pageController.jumpToPage(initialIndex);
          }
        });
      }
    });
  }

  String getDayFromDateTime(DateTime? date) {
    if (date == null) return '';

    const List<String> daysInGerman = [
      'Montag',
      'Dienstag',
      'Mittwoch',
      'Donnerstag',
      'Freitag',
      'Samstag',
      'Sonntag'
    ];

    int dayIndex = date.weekday;
    return daysInGerman[dayIndex - 1];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final day = getDayFromDateTime(currentRecipe.mealPlanEntries.first.day);

    if (recipes.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return BaseScaffold(
      title: day,
      hasBackButton: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center(
                  child: Text(currentRecipe.title ?? '',
                      textAlign: TextAlign.center, style: theme.displaySmall),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height * 2 / 3,
              child: PageView.builder(
                controller: _pageController,
                itemCount: recipes.length,
                onPageChanged: (index) {
                  setState(() {
                    currentRecipe = recipes[index];
                  });
                },
                itemBuilder: (context, index) {
                  Recipe recipe = recipes[index];
                  return RecipePage(recipe: recipe);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
