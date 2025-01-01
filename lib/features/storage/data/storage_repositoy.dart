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

  Future<StorageIngredient> addStorageIngredient(
      Ingredient newIngredient, double count) async {
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
        return storageIngredient;
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

    return newStorageIngredient;
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

  Future<Ingredient> findOrCreateIngredient(
    Map<String, dynamic> ingredientData,
    List<Ingredient> existingIngredients,
    Isar isar,
  ) async {
    return await isar.writeTxn(() async {
      Ingredient ingredient = existingIngredients.firstWhere(
          (i) =>
              i.name == ingredientData['name'] &&
              i.unit == ingredientData['unit'],
          orElse: () => Ingredient()
            ..name = ingredientData['name']
            ..unit = ingredientData['unit']);

      if (ingredient.id == Isar.autoIncrement) {
        await isar.ingredients.put(ingredient);
      }
      return ingredient;
    });
  }

  Future<List<StorageIngredient>?> createStorageIngredientsFromAiResponse(
      dynamic response) async {
    final isar = await isarInstance;

    final existingIngredients = await isar.ingredients.where().findAll();

    final ingredients = <StorageIngredient>[];

    for (var ingredientData in response['ingredients']) {
      final storageRepository = StorageRepository();
      final ingredient = await storageRepository.findOrCreateIngredient(
          ingredientData, existingIngredients, isar);

      StorageIngredient newStorageIngredient = await addStorageIngredient(
        ingredient,
        ingredientData['count'].toDouble(),
      );
      ingredients.add(newStorageIngredient);
    }

    return ingredients;
  }

  Future<List<StorageIngredient>?> updateStorageIngredientsFromAiResponse(
      dynamic response) async {
    final isar = await isarInstance;

    final existingIngredients = await isar.ingredients.where().findAll();

    final ingredients = <StorageIngredient>[];

    for (var ingredientData in response['ingredients']) {
      final storageRepository = StorageRepository();
      final ingredient = await storageRepository.findOrCreateIngredient(
          ingredientData, existingIngredients, isar);

      final storageIngredient = StorageIngredient()
        ..count = ingredientData['count'].toDouble();
      await isar.storageIngredients.put(storageIngredient);

      storageIngredient.ingredient.value = ingredient;
      await storageIngredient.ingredient.save();

      ingredients.add(storageIngredient);
    }

    return ingredients;
  }
}
