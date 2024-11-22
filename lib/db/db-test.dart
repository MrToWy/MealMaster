import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mealmaster/db/user.dart';
import 'package:path_provider/path_provider.dart';


class DbTestScreen extends StatefulWidget {
  @override
  State<DbTestScreen> createState() => _DbTestScreenState();
}

class _DbTestScreenState extends State<DbTestScreen> {
  String? displayedUsername;
  late Future<Isar> isarInstance;

  @override
  void initState() {
    super.initState();
    isarInstance = openIsar();
  }

  Future<Isar> openIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [UserSchema],
      directory: dir.path,
    );
  }

  Future<void> addUser() async {
    final isar = await isarInstance;
    final newUser = User()..name = 'Test User ${DateTime.now().millisecondsSinceEpoch}';

    await isar.writeTxn(() async {
      await isar.users.put(newUser);
    });
  }

  Future<void> loadFirstUser() async {
    final isar = await isarInstance;
    final firstUser = await isar.users.where().findFirst();
    setState(() {
      displayedUsername = firstUser?.name ?? 'No user found';
    });
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
            Text(
              displayedUsername ?? 'No user loaded',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}