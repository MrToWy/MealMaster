import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mealmaster/db/allergy.dart';
import 'package:mealmaster/db/diet.dart';
import 'package:mealmaster/db/example_image.dart';
import 'package:mealmaster/db/ingredient.dart';
import 'package:mealmaster/db/meal_plan.dart';
import 'package:mealmaster/db/meal_plan_entry.dart';
import 'package:mealmaster/db/recipe.dart';
import 'package:mealmaster/db/recipe_ingredient.dart';
import 'package:mealmaster/db/recipe_step.dart';
import 'package:mealmaster/db/storage_ingredient.dart';
import 'package:mealmaster/db/user.dart';
import 'package:mealmaster/shared/open_ai/api_client.dart';
import 'package:path_provider/path_provider.dart';

class DbTestScreen extends StatefulWidget {
  @override
  State<DbTestScreen> createState() => _DbTestScreenState();
}

class _DbTestScreenState extends State<DbTestScreen> {
  String? displayedUsername;
  String? allergies;
  String? diets;
  String? apiKey;
  late Future<Isar> isarInstance;

  @override
  void initState() {
    super.initState();
    isarInstance = openIsar();
  }

  Future<Isar> openIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [
        UserSchema,
        DietSchema,
        AllergySchema,
        IngredientSchema,
        MealPlanSchema,
        MealPlanEntrySchema,
        RecipeSchema,
        RecipeIngredientSchema,
        RecipeStepSchema,
        StorageIngredientSchema,
      ],
      directory: dir.path,
    );
  }

  Future<void> callApiStorageIngredients() async {
    User? user = await loadFirstUser();

    if (user == null) {
      return;
    }

    List<String> images = [];
    images.add(ExampleImage.getFridge());

    final isar = await isarInstance;

    var test = await ApiClient.generateStorageIngredients(images, user, isar);
    test.toString();
  }

  Future<void> callApiMealPlan() async {
    User? user = await loadFirstUser();

    if (user == null) {
      return;
    }

    final isar = await isarInstance;
    final storageItems = await isar.storageIngredients.where().findAll();

    for (var value in storageItems) {
      value.ingredient.loadSync();
    }

    var test2 = await ApiClient.generateMealPlan(storageItems, user, isar);
    test2.toString();
  }

  Future<void> addUser() async {
    final isar = await isarInstance;
    final newUser = User()
      ..name = 'Test User ${DateTime.now().millisecondsSinceEpoch}';
    final allergy = Allergy()..name = "Nuts";
    newUser.allergies.add(allergy);

    await isar.writeTxn(() async {
      await isar.users.put(newUser);
      await isar.allergys.put(allergy);
      await newUser.allergies.save();
    });

    await loadFirstUser();
  }

  Future<User?> loadFirstUser() async {
    final isar = await isarInstance;
    final firstUser = await isar.users.where().findFirst();
    setState(() {
      displayedUsername = firstUser?.name ?? 'No user found';
      diets = firstUser?.diets.join(", ");
      apiKey = firstUser?.apiKey;
      allergies =
          firstUser?.allergies.map((allergy) => allergy.name).join(", ");
    });
    return firstUser;
  }

  Future<void> deleteAllUsers() async {
    final isar = await isarInstance;

    await isar.writeTxn(() async {
      await isar.users.clear();
    });

    await loadFirstUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: callApiStorageIngredients,
              child: Text('Get storage ingredients'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: callApiMealPlan,
              child: Text('Get mealplan'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addUser,
              child: Text('Add New User'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: loadFirstUser,
              child: Text('Load First User'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: deleteAllUsers,
              child: Text('Delete all User'),
            ),
            SizedBox(height: 20),
            Text(
              displayedUsername ?? 'No user loaded',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              (allergies?.isEmpty ?? true)
                  ? 'No allergies'
                  : "Allergies: ${allergies!}",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              (diets?.isEmpty ?? true) ? 'No diets' : "Diets: ${diets!}",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              (apiKey?.isEmpty ?? true) ? 'No api key' : "Api Key: ${apiKey!}",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
