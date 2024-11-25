import 'package:isar/isar.dart';
import 'package:mealmaster/db/meal_plan.dart';
import 'package:mealmaster/db/recipe.dart';
import 'package:mealmaster/db/user.dart';

import 'base/db_entry.dart';
import 'ingredient.dart';
import 'meal_plan_entry.dart';

part 'recipe_ingredient.g.dart';

@collection
class RecipeIngredient extends DbEntry {
  double? count;

  final recipe = IsarLinks<Recipe>();

  @Backlink(to: 'recipeIngredient')
  final ingredients = IsarLinks<Ingredient>();
}