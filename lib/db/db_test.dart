import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mealmaster/db/allergy.dart';
import 'package:mealmaster/db/diet.dart';
import 'package:mealmaster/db/user.dart';
import 'package:path_provider/path_provider.dart';

class DbTestScreen extends StatefulWidget {
  @override
  State<DbTestScreen> createState() => _DbTestScreenState();
}

class _DbTestScreenState extends State<DbTestScreen> {
  String? displayedUsername;
  String? allergies;
  String? diets;
  late Future<Isar> isarInstance;

  @override
  void initState() {
    super.initState();
    isarInstance = openIsar();
  }

  Future<Isar> openIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [UserSchema, DietSchema, AllergySchema],
      directory: dir.path,
    );
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

  Future<void> loadFirstUser() async {
    final isar = await isarInstance;
    final firstUser = await isar.users.where().findFirst();
    setState(() {
      displayedUsername = firstUser?.name ?? 'No user found';
      diets = firstUser?.diets.join(", ");
      allergies =
          firstUser?.allergies.map((allergy) => allergy.name).join(", ");
    });
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
          ],
        ),
      ),
    );
  }
}
