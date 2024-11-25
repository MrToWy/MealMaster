import 'package:isar/isar.dart';
import 'package:mealmaster/db/meal_plan.dart';
import 'package:mealmaster/db/recipe_ingredient.dart';
import 'package:mealmaster/db/storage_ingredient.dart';
import 'package:mealmaster/db/user.dart';

import 'base/db_entry.dart';
import 'meal_plan_entry.dart';

part 'ingredient.g.dart';

@collection
class Ingredient extends DbEntry {
  String? name;
  String? unit;

  final recipeIngredient = IsarLinks<RecipeIngredient>();
  final storageIngredient = IsarLinks<StorageIngredient>();
}