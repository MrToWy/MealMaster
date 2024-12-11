import 'package:isar/isar.dart';
import 'package:mealmaster/db/recipe_ingredient.dart';
import 'package:mealmaster/db/storage_ingredient.dart';

import 'base/db_entry.dart';

part 'ingredient.g.dart';

@collection
class Ingredient extends DbEntry {
  String? name;
  String? unit;

  final recipeIngredients = IsarLinks<RecipeIngredient>();
  final storageIngredients = IsarLinks<StorageIngredient>();
}
