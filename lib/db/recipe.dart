import 'package:isar/isar.dart';
import 'package:mealmaster/db/recipe_ingredient.dart';
import 'package:mealmaster/db/recipe_step.dart';

import 'base/db_entry.dart';
import 'meal_plan_entry.dart';

part 'recipe.g.dart';

@collection
class Recipe extends DbEntry {
  String? title;
  String? description;
  int? cookingDuration;
  int? difficulty;

  @Backlink(to: 'recipe')
  final ingredients = IsarLinks<RecipeIngredient>();
  @Backlink(to: 'recipe')
  final steps = IsarLinks<RecipeStep>();
  @Backlink(to: 'recipe')
  final mealPlanEntries = IsarLinks<MealPlanEntry>();
}
