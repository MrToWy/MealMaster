import 'package:isar/isar.dart';

import '../../../db/isar_factory.dart';
import '../../../db/meal_plan.dart';
import '../../../db/meal_plan_entry.dart';
import '../../../db/recipe.dart';
import '../../meal_plan/data/meal_plan_repository.dart';

class RecipeRepository {
  static final RecipeRepository _instance = RecipeRepository._internal();
  late Future<Isar> isarInstance = IsarFactory().db;

  factory RecipeRepository() {
    return _instance;
  }

  RecipeRepository._internal();

  Future<List<Recipe>> getRecipes() async {
    MealPlan mealPlan = await MealPlanRepository().getCurrentMealPlan();
    List<MealPlanEntry> entries =
        await MealPlanRepository().getMealPlanEntries(mealPlan);

    final List<Recipe> allRecipes = [];

    for (final entry in entries) {
      await entry.recipe.load();
      final recipe = entry.recipe.value;

      if (recipe != null) {
        allRecipes.add(recipe);
      }
    }
    return allRecipes;
  }

  Future<Recipe> getRecipeById(int id) async {
    final recipes = getRecipes();
    return recipes
        .then((value) => value.firstWhere((element) => element.id == id));
  }
}
