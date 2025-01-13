import 'package:isar/isar.dart';
import 'package:mealmaster/db/ingredient.dart';
import 'package:mealmaster/db/recipe.dart';
import 'package:mealmaster/features/recipes/data/recipe_repository.dart';

import '../../../db/isar_factory.dart';
import '../../../db/meal_plan.dart';
import '../../../db/meal_plan_entry.dart';

class MealPlanRepository {
  static final MealPlanRepository _instance = MealPlanRepository._internal();
  late Future<Isar> isarInstance = IsarFactory().db;

  factory MealPlanRepository() {
    return _instance;
  }

  MealPlanRepository._internal();

  Future<MealPlan> getCurrentMealPlan() async {
    final isar = await isarInstance;
    final mealPlan =
        await isar.mealPlans.where().sortByStartDateDesc().findFirst();

    if (mealPlan == null) {
      throw Exception("No meal plan found");
    }

    return mealPlan;
  }

  Future<bool> checkIfMealPlanExists() async {
    final isar = await isarInstance;
    final mealPlan =
        await isar.mealPlans.where().sortByStartDateDesc().findFirst();
    return mealPlan != null;
  }

  Future<List<MealPlanEntry>> getMealPlanEntries() async {
    MealPlan currentMealPlan = await getCurrentMealPlan();
    await currentMealPlan.entries.load();
    final entries = currentMealPlan.entries.toList();

    if (entries.isEmpty) {
      throw Exception("No entries found for meal plan");
    }

    return entries;
  }

  Future<MealPlan?> createMealPlanFromAiResponse(
    List<dynamic> entries,
  ) async {
    final isar = await isarInstance;
    final existingIngredients = await isar.ingredients.where().findAll();

    final mealPlan = await _createMealPlanObject();
    await _processMealPlanEntries(entries, mealPlan, existingIngredients, isar);
    return mealPlan;
  }

  Future<MealPlan> _createMealPlanObject() async {
    final isar = await isarInstance;
    return await isar.writeTxn(() async {
      final mealPlan = MealPlan()
        ..startDate = DateTime.now()
        ..endDate = DateTime.now().add(Duration(days: 5));
      await isar.mealPlans.put(mealPlan);
      return mealPlan;
    });
  }

  Future<void> _processMealPlanEntries(List<dynamic> entries, MealPlan mealPlan,
      List<Ingredient> existingIngredients, Isar isar) async {
    final recipeRepository = RecipeRepository();
    for (var entryData in entries) {
      final mealPlanEntry = await _createMealPlanEntry(entryData, mealPlan);
      final recipe = await recipeRepository.createRecipeFromAiResponse(
          entryData['recipe'], existingIngredients, mealPlanEntry, isar);
      await _linkMealPlanEntryToRecipe(mealPlanEntry, recipe, isar);
    }
  }

  Future<MealPlanEntry> _createMealPlanEntry(
      Map<String, dynamic> entryData, MealPlan mealPlan) async {
    final isar = await isarInstance;
    return await isar.writeTxn(() async {
      final mealPlanEntry = MealPlanEntry()
        ..day = DateTime.now().add(Duration(days: entryData['dayNumber'] - 1));
      await isar.mealPlanEntrys.put(mealPlanEntry);
      mealPlanEntry.mealPlan.value = mealPlan;
      await mealPlanEntry.mealPlan.save();
      return mealPlanEntry;
    });
  }

  static Future<void> _linkMealPlanEntryToRecipe(
      MealPlanEntry entry, Recipe recipe, Isar isar) async {
    await isar.writeTxn(() async {
      entry.recipe.value = recipe;
      await entry.recipe.save();
    });
  }
}
