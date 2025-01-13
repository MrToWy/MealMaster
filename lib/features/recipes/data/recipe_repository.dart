import 'package:isar/isar.dart';

import '../../../db/ingredient.dart';
import '../../../db/isar_factory.dart';
import '../../../db/meal_plan_entry.dart';
import '../../../db/recipe.dart';
import '../../../db/recipe_ingredient.dart';
import '../../../db/recipe_step.dart';
import '../../meal_plan/data/meal_plan_repository.dart';
import '../../storage/data/storage_repository.dart';

class RecipeRepository {
  static final RecipeRepository _instance = RecipeRepository._internal();
  late Future<Isar> isarInstance = IsarFactory().db;

  factory RecipeRepository() {
    return _instance;
  }

  RecipeRepository._internal();

  Future<List<Recipe>> getRecipes() async {
    List<MealPlanEntry> entries =
        await MealPlanRepository().getMealPlanEntries();

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

  Future<List<Recipe>> getRemainingRecipes() async {
    List<MealPlanEntry> entries =
        await MealPlanRepository().getMealPlanEntries();
    entries = entries
        .where((element) =>
            element.day!.isAfter(DateTime.now().subtract(Duration(days: 1))))
        .toList();

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

  Future<Recipe> createRecipeFromAiResponse(
      Map<String, dynamic> recipeData,
      List<Ingredient> existingIngredients,
      MealPlanEntry entry,
      Isar isar) async {
    var difficulty = recipeData['difficulty'];
    if (recipeData['difficulty'] > 3) {
      difficulty = 3;
    }
    if (recipeData['difficulty'] < 1) {
      difficulty = 1;
    }
    final recipe = Recipe()
      ..title = recipeData['name']
      ..description = recipeData['description']
      ..difficulty = difficulty
      ..cookingDuration = recipeData['steps']
          .fold<int>(0, (sum, step) => sum + step['duration'] as int);
    await isar.writeTxn(() async {
      await isar.recipes.put(recipe);
    });
    await _processRecipeIngredients(
        recipeData['ingredients'], recipe, existingIngredients, isar);
    await _processRecipeSteps(recipeData['steps'], recipe, isar);
    return recipe;
  }

  Future<void> _processRecipeIngredients(List<dynamic> ingredients,
      Recipe recipe, List<Ingredient> existingIngredients, Isar isar) async {
    for (var ingredientData in ingredients) {
      final storageRepository = StorageRepository();
      final ingredient = await storageRepository.findOrCreateIngredient(
          ingredientData, existingIngredients, isar);
      await _createRecipeIngredient(ingredientData, recipe, ingredient, isar);
    }
  }

  static Future<void> _processRecipeSteps(
      List<dynamic> steps, Recipe recipe, Isar isar) async {
    await isar.writeTxn(() async {
      for (var stepData in steps) {
        final recipeStep = RecipeStep()
          ..orderPosition = stepData['stepNumber']
          ..description = stepData['instruction'];
        await isar.recipeSteps.put(recipeStep);
        recipe.steps.add(recipeStep);
      }
      await recipe.steps.save();
    });
  }

  static Future<void> _createRecipeIngredient(
      Map<String, dynamic> ingredientData,
      Recipe recipe,
      Ingredient ingredient,
      Isar isar) async {
    await isar.writeTxn(() async {
      final recipeIngredient = RecipeIngredient()
        ..count = ingredientData['count'].toDouble();
      await isar.recipeIngredients.put(recipeIngredient);
      recipeIngredient.recipe.value = recipe;
      await recipeIngredient.recipe.save();
      recipeIngredient.ingredient.value = ingredient;
      await recipeIngredient.ingredient.save();
    });
  }
}
