import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'allergy.dart';
import 'diet.dart';
import 'ingredient.dart';
import 'meal_plan.dart';
import 'meal_plan_entry.dart';
import 'recipe.dart';
import 'recipe_ingredient.dart';
import 'recipe_step.dart';
import 'storage_ingredient.dart';
import 'user.dart';

class IsarFactory {
  static final IsarFactory _instance = IsarFactory._internal();
  late Future<Isar> db = _openIsar();

  factory IsarFactory() {
    return _instance;
  }

  IsarFactory._internal();

  Future<Isar> _openIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [
        UserSchema,
        DietSchema,
        AllergySchema,
        RecipeSchema,
        RecipeIngredientSchema,
        IngredientSchema,
        RecipeStepSchema,
        MealPlanEntrySchema,
        MealPlanSchema,
        StorageIngredientSchema
      ],
      directory: dir.path,
    );
  }
} 