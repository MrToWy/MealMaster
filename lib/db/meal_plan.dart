import 'package:isar/isar.dart';

import 'base/db_entry.dart';
import 'meal_plan_entry.dart';

part 'meal_plan.g.dart';

@collection
class MealPlan extends DbEntry {
  DateTime? startDate;
  DateTime? endDate;

  @Backlink(to: 'mealPlan')
  final entries = IsarLinks<MealPlanEntry>();
}
