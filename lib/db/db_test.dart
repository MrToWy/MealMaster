import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../common/widgets/base_scaffold.dart';
import '../shared/open_ai/api_client.dart';
import 'allergy.dart';
import 'example_image.dart';
import 'isar_factory.dart';
import 'storage_ingredient.dart';
import 'user.dart';

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
    isarInstance = IsarFactory().db;
  }

  Future<void> callApiStorageIngredients() async {
    User? user = await loadFirstUser();

    if (user == null) {
      return;
    }

    List<String> images = [];
    images.add(ExampleImage.getFridge());

    var test = await ApiClient.generateStorageIngredients(images);
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
    return BaseScaffold(
      title: 'DB Test',
      hasBackButton: true,
      child: Center(
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
