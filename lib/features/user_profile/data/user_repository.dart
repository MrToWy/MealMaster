import 'package:isar/isar.dart';
import 'package:mealmaster/db/allergy.dart';
import 'package:mealmaster/db/isar_factory.dart';
import 'package:mealmaster/db/user.dart';
import 'package:mealmaster/features/user_profile/domain/allergies_enum.dart';
import 'package:mealmaster/features/user_profile/domain/user.dart';

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

    List<Allergy> dbAllergies = await isar.allergys.where().findAll();
    var allergies = allergyEnumToDBEnum(allergiesEnum);
    List<Allergy> finalAllergies = [];
    for (Allergy al in allergies) {
      if (dbAllergies.where((e) => al.name == e.name).isEmpty) {
        finalAllergies.add(al);
      } else {
        finalAllergies.add(dbAllergies.firstWhere((e) => al.name == e.name));
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

  Future<bool> createUser(String userName, String weightString, String apiKey,
      Set<AllergiesEnum> allergiesEnum) async {
    //TODO add Allergies and diet
    final isar = await isarInstance;
    final newUser = User()..name = userName;
    double? weight = double.tryParse(weightString);
    newUser.weight = weight;
    newUser.apiKey = apiKey;

    List<Allergy> dbAllergies = await isar.allergys.where().findAll();
    var allergies = allergyEnumToDBEnum(allergiesEnum);
    List<Allergy> finalAllergies = [];
    for (Allergy al in allergies) {
      if (dbAllergies.where((e) => al.name == e.name).isEmpty) {
        finalAllergies.add(al);
      } else {
        finalAllergies.add(dbAllergies.firstWhere((e) => al.name == e.name));
      }
    }
    newUser.allergies.clear();
    newUser.allergies.addAll(finalAllergies);

    await isar.writeTxn(() async {
      await isar.allergys.putAll(finalAllergies);
      await isar.users.put(newUser);
      await newUser.allergies.save();
    });
    return true;
  }

  Future<bool> hasUser() async {
    final isar = await isarInstance;
    final firstUser = await isar.users.where().findFirst();
    if (firstUser == null) {
      return false;
    }
    return true;
  }

  Future<String> getAPIKey() async {
    final isar = await isarInstance;
    final user = await isar.users.where().findFirst();
    if (user == null) {
      return "Error: kein User vorhanden";
    }
    String key = user.apiKey ?? "Error: Kein API-Key vorhanden";
    return key;
  }

  Future<bool> setAPIKey(String apiKey) async {
    final isar = await isarInstance;
    final user = await isar.users.where().findFirst();
    if (user == null) {
      return false;
    }
    user.apiKey = apiKey;
    await isar.writeTxn(() async {
      await isar.users.put(user);
    });
    return true;
  }

  Future<UserRepresentation?> getUserRepresentation() async {
    final isar = await isarInstance;
    final firstUser = await isar.users.where().findFirst();
    if (firstUser == null) {
      return null;
    }
    String name = firstUser.name ?? "Kein Name vorhanden";
    String weight = firstUser.weight.toString();

    var allergies = firstUser.allergies;
    Set<AllergiesEnum> allergiesEnum = {};
    for (var allergy in allergies) {
      try {
        var tempAllergie =
            AllergiesEnum.values.firstWhere((e) => e.key == allergy.name);
        allergiesEnum.add(tempAllergie);
      } catch (e) {
        //TODO: ADD Error Message if allergie was not found
      }
    }

    return UserRepresentation(
        name: name, weight: weight, allergies: allergiesEnum);
  }
}
