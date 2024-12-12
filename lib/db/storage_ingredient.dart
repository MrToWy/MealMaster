import 'package:isar/isar.dart';
import 'package:mealmaster/db/ingredient.dart';

import 'base/db_entry.dart';

part 'storage_ingredient.g.dart';

@collection
class StorageIngredient extends DbEntry {
  double? count;

  final ingredient = IsarLink<Ingredient>();
}
