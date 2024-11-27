import 'package:isar/isar.dart';
import 'package:mealmaster/db/meal_plan.dart';

import 'base/db_entry.dart';

part 'meal_plan_entry.g.dart';

@collection
class MealPlanEntry extends DbEntry {
  DateTime? day;

  final mealPlan = IsarLinks<MealPlan>();
}
