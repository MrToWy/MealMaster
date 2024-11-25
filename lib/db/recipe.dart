import 'package:isar/isar.dart';
import 'package:mealmaster/db/meal_plan.dart';
import 'package:mealmaster/db/recipe_ingredient.dart';
import 'package:mealmaster/db/recipe_step.dart';
import 'package:mealmaster/db/user.dart';

import 'base/db_entry.dart';
import 'meal_plan_entry.dart';

part 'recipe.g.dart';

@collection
class Recipe extends DbEntry {
  int? cookingDuration;
  int? difficulty;

  final mealPlanEntry = IsarLinks<MealPlanEntry>();

  @Backlink(to: 'recipe')

  final ingredients = IsarLinks<RecipeIngredient>();
  @Backlink(to: 'recipe')
  final steps = IsarLinks<RecipeStep>();
}