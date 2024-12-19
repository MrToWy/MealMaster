import 'package:isar/isar.dart';
import 'package:mealmaster/db/ingredient.dart';
import 'package:mealmaster/db/isar_factory.dart';
import 'dart:developer';

import 'package:mealmaster/db/storage_ingredient.dart';

class StorageRepository {
  static final StorageRepository _instance = StorageRepository._internal();
  late Future<Isar> isarInstance = IsarFactory().db;

  StorageRepository._internal();

  factory StorageRepository() {
    return _instance;
  }

  void addToStorage(Ingredient newItem, double count) async {
    final db = await isarInstance;

    final existingStorageIngredient =
        await db.storageIngredients.filter().ingredient((q) {
      return q.nameEqualTo(newItem.name);
    }).findFirst();

    final existingStorageIngredients = await db.storageIngredients
        .filter()
        .ingredient((q) => q.nameIsNotNull())
        .findAll();

    for (var storageIngredient in existingStorageIngredients) {
      log("Comparing with existing ingredient: ${storageIngredient.ingredient.value?.name}");
    }

    if (existingStorageIngredient != null) {
      existingStorageIngredient.count =
          (existingStorageIngredient.count ?? 0) + count;

      await db.writeTxn(() async {
        await db.storageIngredients.put(existingStorageIngredient);
      });
    } else {
      final storageIngredient = StorageIngredient()
        ..ingredient.value = newItem
        ..count = count;
      log("Created storageingredient with ingredient: ${storageIngredient.ingredient.value?.name}");

      await db.writeTxn(() async {
        await db.storageIngredients.put(storageIngredient);
      });
    }

    log("StorageIngredient added/updated successfully");
  }

  void test() {
    log("Test storage repo");
  }
}
