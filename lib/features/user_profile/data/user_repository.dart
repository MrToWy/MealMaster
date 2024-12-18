import 'package:isar/isar.dart';
import 'package:mealmaster/db/allergy.dart';
import 'package:mealmaster/db/isar_factory.dart';
import 'package:mealmaster/db/user.dart';
import 'package:mealmaster/features/user_profile/domain/allergies_enum.dart';

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

  Future<Set<AllergiesEnum>> getAllergies() async {
    final isar = await isarInstance;
    final firstUser = await isar.users.where().findFirst();
    var allergies = firstUser?.allergies;
    Set<AllergiesEnum> allergiesEnum = {};
    if (allergies == null) {
      return allergiesEnum;
    }
    for (var allergy in allergies) {
      try {
        var tempAllergie =
            AllergiesEnum.values.firstWhere((e) => e.key == allergy.name);
        allergiesEnum.add(tempAllergie);
      } catch (e) {
        //TODO: ADD Error Message if allergie was not found
      }
    }
    return allergiesEnum;
  }

  Future<bool> saveUserData(String userName, String weightString,
      Set<AllergiesEnum> allergiesEnum) async {
    final isar = await isarInstance;
    final firstUser = await isar.users.where().findFirst();
    if (firstUser == null) {
      return false;
    }
    //TODO: FIX
    //allergies are still saved twice
    List<Allergy> dbAllergies = await isar.allergys.where().findAll();
    var allergies = allergyEnumToDBEnum(allergiesEnum);
    List<Allergy> finalAllergies = [];
    for (Allergy al in allergies) {
      if (dbAllergies.where((e) => al.name == e.name).isEmpty) {
        finalAllergies.add(dbAllergies.firstWhere((e) => al.name == e.name));
      } else {
        finalAllergies.add(al);
      }
    }
    firstUser.allergies.clear();
    firstUser.allergies.addAll(finalAllergies);
    firstUser.name = userName;
    double? weight = double.tryParse(weightString);
    firstUser.weight = weight;

    await isar.writeTxn(() async {
      await isar.allergys.putAll(finalAllergies);
      await isar.users.put(firstUser);
      await firstUser.allergies.save();
    });

    return true;
  }

  Set<Allergy> allergyEnumToDBEnum(Set<AllergiesEnum> allergiesEnum) {
    Set<Allergy> result = {};
    for (AllergiesEnum allergy in allergiesEnum) {
      Allergy temp = Allergy()..name = allergy.key;
      result.add(temp);
    }
    return result;
  }

  Future<bool> createUser(String userName, String weightString) async {
    return true;
  }
}
