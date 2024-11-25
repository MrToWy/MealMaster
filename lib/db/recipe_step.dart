import 'package:isar/isar.dart';
import 'package:mealmaster/db/recipe.dart';

import 'base/db_entry.dart';

part 'recipe_step.g.dart';

@collection
class RecipeStep extends DbEntry {
  int? orderPosition;
  String? description;

  final recipe = IsarLinks<Recipe>();
}