import 'package:isar/isar.dart';

import '../../../db/isar_factory.dart';
import '../../../db/meal_plan.dart';
import '../../../db/meal_plan_entry.dart';

class MealPlanRepository {
  static final MealPlanRepository _instance = MealPlanRepository._internal();
  late Future<Isar> isarInstance = IsarFactory().db;

  factory MealPlanRepository() {
    return _instance;
  }

  MealPlanRepository._internal();

  Future<MealPlan> getCurrentMealPlan() async {
    final isar = await isarInstance;
    final mealPlan =
        await isar.mealPlans.where().sortByStartDateDesc().findFirst();

    if (mealPlan == null) {
      throw Exception("No meal plan found");
    }

    return mealPlan;
  }

  Future<List<MealPlanEntry>> getMealPlanEntries(MealPlan mealPlan) async {
    await mealPlan.entries.load();
    final entries = mealPlan.entries.toList();

    if (entries.isEmpty) {
      throw Exception("No entries found for meal plan");
    }

    return entries;
  }
}
