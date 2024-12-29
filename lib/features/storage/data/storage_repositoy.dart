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

  void addToStorage(Ingredient newIngredient, double count) async {
    final db = await isarInstance;

    //check if ingredient already exists in Storage
    final storageIngredients = await db.storageIngredients.where().findAll();
    for (final storageIngredient in storageIngredients) {
      await storageIngredient.ingredient.load();

      final linkedIngredient = storageIngredient.ingredient.value;
      if (linkedIngredient != null &&
          linkedIngredient.name == newIngredient.name) {
        //update amount of exisiting storageingredient
        storageIngredient.count = (storageIngredient.count ?? 0) + count;
        await db.writeTxn(() async {
          await db.storageIngredients.put(storageIngredient);
        });
        return;
      }
    }

    //create mew storageingredient, if it doesnt exist already
    final newStorageIngredient = StorageIngredient()
      ..ingredient.value = newIngredient
      ..count = count;
    await db.writeTxn(() async {
      await db.storageIngredients.put(newStorageIngredient);
      await newStorageIngredient.ingredient.save();
    });
  }

  void removeFromStorage(Ingredient ingredientToRemove, double count) async {
    final db = await isarInstance;

    // Check if ingredient exists in Storage
    final storageIngredients = await db.storageIngredients.where().findAll();
    for (final storageIngredient in storageIngredients) {
      await storageIngredient.ingredient.load();

      final linkedIngredient = storageIngredient.ingredient.value;
      if (linkedIngredient != null &&
          linkedIngredient.name == ingredientToRemove.name) {
        log('Match found: ${linkedIngredient.name}');
        storageIngredient.count = (storageIngredient.count ?? 0) - count;

        // If the count becomes 0 or negative, remove the StorageIngredient
        if (storageIngredient.count != null && storageIngredient.count! <= 0) {
          log('Count is zero or negative. Removing ingredient from storage.');
          await db.writeTxn(() async {
            await db.storageIngredients.delete(storageIngredient.id);
          });
        } else {
          // Otherwise, update the StorageIngredient in the database
          await db.writeTxn(() async {
            await db.storageIngredients.put(storageIngredient);
          });
        }
        return;
      }
    }

    log('No match found. Nothing to remove.');
  }

  void test() {
    log("Test storage repo");
  }
}
