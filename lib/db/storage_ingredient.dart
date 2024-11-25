import 'package:isar/isar.dart';
import 'package:mealmaster/db/ingredient.dart';
import 'package:mealmaster/db/meal_plan.dart';
import 'package:mealmaster/db/user.dart';

import 'base/db_entry.dart';
import 'meal_plan_entry.dart';

part 'storage_ingredient.g.dart';

@collection
class StorageIngredient extends DbEntry {
  double? count;

  final ingredient = IsarLinks<Ingredient>();
}