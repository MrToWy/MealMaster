import 'package:isar/isar.dart';
import 'package:mealmaster/db/isar_factory.dart';
import 'package:mealmaster/db/user.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();
  late Future<Isar> isarInstance = IsarFactory().db;
  
  factory UserRepository() {
    return _instance;
  }
  
  UserRepository._internal();

  Future<String> getUserName() async {
    final isar = await isarInstance;
    final firstUser = await isar.users.where().findFirst();
    return firstUser?.name ?? "Kein Name vorhanden";
  }

  Future<User> getUser() async {
    final isar = await isarInstance;
    final firstUser = await isar.users.where().findFirst();

    if (firstUser == null) throw Exception("Coudlnt fetch user");

    return firstUser;
  }

  Future<String> getWeightString() async {
    final isar = await isarInstance;
    final firstUser = await isar.users.where().findFirst();
    return firstUser?.weight.toString() ?? "Kein Gewicht vorhanden";
  }
}
