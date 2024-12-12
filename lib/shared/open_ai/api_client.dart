import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';

import '../../db/ingredient.dart';
import '../../db/isar_factory.dart';
import '../../db/meal_plan.dart';
import '../../db/meal_plan_entry.dart';
import '../../db/recipe.dart';
import '../../db/recipe_ingredient.dart';
import '../../db/recipe_step.dart';
import '../../db/storage_ingredient.dart';
import '../../db/user.dart';
import '../../features/user_profile/data/user_repository.dart';
import 'ai_function.dart';
import 'content.dart';
import 'message.dart';
import 'request_body.dart';

class ApiClient {
  static bool _validateRequest(
      List<dynamic> items, User user, String itemType) {
    if (items.isEmpty) {
      developer.log('No $itemType provided', name: 'OpenAI');
      return false;
    }
    if (user.apiKey == null) {
      developer.log('No api key provided', name: 'OpenAI');
      return false;
    }
    return true;
  }

  static Future<Ingredient> _findOrCreateIngredient(
    Map<String, dynamic> ingredientData,
    List<Ingredient> existingIngredients,
    Isar isar,
  ) async {
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
  }

  /// Analyzes images to detect ingredients and their quantities, storing them in the database.
  ///
  /// [images] List of base64 encoded image strings to analyze
  /// [user] The user making the request, must have a valid API key
  /// [isar] Database instance for storing the results
  ///
  /// Returns a list of [StorageIngredient] objects if successful, null otherwise.
  static Future<List<StorageIngredient>?> generateStorageIngredients(
      List<String> images) async {
    final user = await UserRepository().getUser();
    final isar = await IsarFactory().db;

    if (!_validateRequest(images, user, 'images')) return null;

    final requestBody = RequestBody(
      model: 'gpt-4o',
      messages: [
        Message(
          role: 'user',
          content: [
            Content(
              type: 'text',
              value:
                  'Analysieren Sie diese Bilder und identifizieren Sie alle Zutaten mit ihren ungefähren Mengenangaben.',
            ),
            ...images.map((image) => Content(
                  type: 'image_url',
                  value: {'url': "data:image/png;base64,$image"},
                )),
          ],
        ),
      ],
      functions: [
        AiFunction(
          name: 'detect_ingredients',
          description: 'Detects ingredients from images',
          parameters: {
            'type': 'object',
            'properties': {
              'ingredients': {
                'type': 'array',
                'items': {
                  'type': 'object',
                  'properties': {
                    'name': {
                      'type': 'string',
                      'description': 'Name of the ingredient'
                    },
                    'count': {
                      'type': 'number',
                      'description': 'Count of the ingredient'
                    },
                    'unit': {
                      'type': 'string',
                      'description': 'Unit of measurement'
                    },
                  },
                  'required': ['name', 'count', 'unit'],
                },
              },
            },
            'required': ['ingredients'],
          },
        ),
      ],
      functionCall: {'name': 'detect_ingredients'},
      maxTokens: 300,
    );

    try {
      final response = await _makeApiCall(requestBody, user.apiKey!);
      if (response != null) {
        final functionCall = response['choices'][0]['message']['function_call'];
        final arguments = jsonDecode(functionCall['arguments']);

        final existingIngredients = await isar.ingredients.where().findAll();

        return await isar.writeTxn(() async {
          final ingredients = <StorageIngredient>[];

          for (var ingredientData in arguments['ingredients']) {
            final ingredient = await _findOrCreateIngredient(
                ingredientData, existingIngredients, isar);

            final storageIngredient = StorageIngredient()
              ..count = ingredientData['count'].toDouble();
            await isar.storageIngredients.put(storageIngredient);

            storageIngredient.ingredient.value = ingredient;
            await storageIngredient.ingredient.save();

            ingredients.add(storageIngredient);
          }

          return ingredients;
        });
      }
      return null;
    } catch (e) {
      developer.log('Exception: $e', name: 'OpenAI');
      return null;
    }
  }

  /// Generates a 5-day meal plan based on available ingredients.
  ///
  /// [ingredients] List of ingredients available to use in the meal plan
  /// [user] The user making the request, must have a valid API key
  /// [isar] Database instance for storing the results
  ///
  /// Returns a [MealPlan] object if successful, null otherwise.
  static Future<MealPlan?> generateMealPlan(
      List<StorageIngredient> ingredients, User user, Isar isar) async {
    if (!_validateRequest(ingredients, user, 'ingredients')) return null;

    final requestBody = RequestBody(
      model: 'gpt-4',
      messages: [
        Message(
          role: 'user',
          content: [
            Content(
              type: 'text',
              value:
                  'Erstellen Sie einen 5-Tage-Mahlzeitenplan mit diesen Zutaten. Es dürfen auch andere Zutaten genutzt werden, um nicht jeden Tag ähnliches zu essen. Die genannten Zutaten sollten aber wenn möglich aufgebraucht werden. ${ingredients.map((i) => "${i.ingredient.value?.name}: ${i.count} ${i.ingredient.value?.unit}").join(", ")}',
            ),
          ],
        ),
      ],
      functions: [
        AiFunction(
          name: 'generate_meal_plan',
          description: 'Generates a meal plan with recipes',
          parameters: {
            'type': 'object',
            'properties': {
              'mealPlan': {
                'type': 'object',
                'properties': {
                  'entries': {
                    'type': 'array',
                    'items': {
                      'type': 'object',
                      'properties': {
                        'dayNumber': {
                          'type': 'integer',
                          'description': 'Day number (1-5)'
                        },
                        'recipe': {
                          'type': 'object',
                          'properties': {
                            'name': {
                              'type': 'string',
                              'description': 'Name of the recipe'
                            },
                            'description': {
                              'type': 'string',
                              'description': 'Brief description of the recipe'
                            },
                            'ingredients': {
                              'type': 'array',
                              'items': {
                                'type': 'object',
                                'properties': {
                                  'name': {
                                    'type': 'string',
                                    'description': 'Name of the ingredient'
                                  },
                                  'count': {
                                    'type': 'number',
                                    'description': 'Amount needed'
                                  },
                                  'unit': {
                                    'type': 'string',
                                    'description': 'Unit of measurement'
                                  }
                                },
                                'required': ['name', 'count', 'unit']
                              }
                            },
                            'steps': {
                              'type': 'array',
                              'items': {
                                'type': 'object',
                                'properties': {
                                  'stepNumber': {
                                    'type': 'integer',
                                    'description': 'Order of the step'
                                  },
                                  'instruction': {
                                    'type': 'string',
                                    'description': 'Step instruction'
                                  },
                                  'duration': {
                                    'type': 'integer',
                                    'description': 'Duration in minutes'
                                  }
                                },
                                'required': [
                                  'stepNumber',
                                  'instruction',
                                  'duration'
                                ]
                              }
                            }
                          },
                          'required': [
                            'name',
                            'description',
                            'ingredients',
                            'steps'
                          ]
                        }
                      },
                      'required': ['dayNumber', 'recipe']
                    }
                  }
                },
                'required': ['entries']
              }
            },
            'required': ['mealPlan']
          },
        ),
      ],
      functionCall: {'name': 'generate_meal_plan'},
      maxTokens: 3000,
    );

    try {
      final response = await _makeApiCall(requestBody, user.apiKey!);
      if (response != null) {
        final existingIngredients = await isar.ingredients.where().findAll();
        final functionCall = response['choices'][0]['message']['function_call'];
        final arguments = jsonDecode(functionCall['arguments']);

        return await isar.writeTxn(() async {
          final mealPlan = await _createMealPlan(isar);
          await _processMealPlanEntries(arguments['mealPlan']['entries'],
              mealPlan, existingIngredients, isar);
          return mealPlan;
        });
      }
      return null;
    } catch (e) {
      developer.log('Exception: $e', name: 'OpenAI');
      return null;
    }
  }

  static Future<MealPlan> _createMealPlan(Isar isar) async {
    final mealPlan = MealPlan()
      ..startDate = DateTime.now()
      ..endDate = DateTime.now().add(Duration(days: 5));
    await isar.mealPlans.put(mealPlan);
    return mealPlan;
  }

  static Future<void> _processMealPlanEntries(
      List<dynamic> entries,
      MealPlan mealPlan,
      List<Ingredient> existingIngredients,
      Isar isar) async {
    for (var entryData in entries) {
      final mealPlanEntry =
          await _createMealPlanEntry(entryData, mealPlan, isar);
      final recipe = await _createRecipe(
          entryData['recipe'], existingIngredients, mealPlanEntry, isar);
      await _linkMealPlanEntryToRecipe(mealPlanEntry, recipe, isar);
    }
  }

  static Future<MealPlanEntry> _createMealPlanEntry(
      Map<String, dynamic> entryData, MealPlan mealPlan, Isar isar) async {
    final mealPlanEntry = MealPlanEntry()
      ..day = DateTime.now().add(Duration(days: entryData['dayNumber'] - 1));
    await isar.mealPlanEntrys.put(mealPlanEntry);
    mealPlanEntry.mealPlan.value = mealPlan;
    await mealPlanEntry.mealPlan.save();
    return mealPlanEntry;
  }

  static Future<Recipe> _createRecipe(
      Map<String, dynamic> recipeData,
      List<Ingredient> existingIngredients,
      MealPlanEntry entry,
      Isar isar) async {
    final recipe = Recipe()
      ..title = recipeData['name']
      ..description = recipeData['description']
      ..cookingDuration = recipeData['steps']
          .fold<int>(0, (sum, step) => sum + step['duration'] as int);

    await isar.recipes.put(recipe);
    await _processRecipeIngredients(
        recipeData['ingredients'], recipe, existingIngredients, isar);
    await _processRecipeSteps(recipeData['steps'], recipe, isar);
    return recipe;
  }

  static Future<void> _processRecipeIngredients(List<dynamic> ingredients,
      Recipe recipe, List<Ingredient> existingIngredients, Isar isar) async {
    for (var ingredientData in ingredients) {
      final ingredient = await _findOrCreateIngredient(
          ingredientData, existingIngredients, isar);
      await _createRecipeIngredient(ingredientData, recipe, ingredient, isar);
    }
  }

  static Future<void> _createRecipeIngredient(
      Map<String, dynamic> ingredientData,
      Recipe recipe,
      Ingredient ingredient,
      Isar isar) async {
    final recipeIngredient = RecipeIngredient()
      ..count = ingredientData['count'].toDouble();
    await isar.recipeIngredients.put(recipeIngredient);
    recipeIngredient.recipe.value = recipe;
    await recipeIngredient.recipe.save();
    recipeIngredient.ingredient.value = ingredient;
    await recipeIngredient.ingredient.save();
  }

  static Future<void> _processRecipeSteps(
      List<dynamic> steps, Recipe recipe, Isar isar) async {
    for (var stepData in steps) {
      final recipeStep = RecipeStep()
        ..orderPosition = stepData['stepNumber']
        ..description = stepData['instruction'];
      await isar.recipeSteps.put(recipeStep);
      recipe.steps.add(recipeStep);
    }
    await recipe.steps.save();
  }

  static Future<void> _linkMealPlanEntryToRecipe(
      MealPlanEntry entry, Recipe recipe, Isar isar) async {
    entry.recipe.value = recipe;
    await entry.recipe.save();
  }

  static Future<Map<String, dynamic>?> _makeApiCall(
      RequestBody requestBody, String apiKey) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(requestBody.toJson()),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        developer.log('Error: ${response.statusCode}', name: 'OpenAI');
        developer.log('Response: ${response.body}', name: 'OpenAI');
        return null;
      }
    } catch (e) {
      developer.log('Exception: $e', name: 'OpenAI');
      return null;
    }
  }

  static Future<String?> transcribeAudio(String filePath) async {
    final user = await UserRepository().getUser();

    if (user.apiKey == null) {
      developer.log('No api key provided', name: 'OpenAI');
      return null;
    }

    try {
      final file = File(filePath);

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.openai.com/v1/audio/transcriptions'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer ${user.apiKey!}',
      });

      request.fields['model'] = 'whisper-1';

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['text'];
      } else {
        developer.log('Error: ${response.statusCode}', name: 'OpenAI');
        developer.log('Response: ${response.body}', name: 'OpenAI');
        return null;
      }
    } catch (e) {
      developer.log('Exception: $e', name: 'OpenAI');
      return null;
    }
  }

  static Future<List<StorageIngredient>?> updateIngredientsFromText(
      List<StorageIngredient> currentIngredients, String text) async {
    final user = await UserRepository().getUser();
    final isar = await IsarFactory().db;

    if (!_validateRequest([text], user, 'text')) return null;

    final requestBody = RequestBody(
      model: 'gpt-4',
      messages: [
        Message(
          role: 'user',
          content: [
            Content(
              type: 'text',
              value: '''
Aktuelle Zutaten:
${currentIngredients.map((i) => "${i.ingredient.value?.name}: ${i.count} ${i.ingredient.value?.unit}").join("\n")}

Änderungen:
$text

Bitte aktualisiere die Zutatenliste entsprechend der Änderungen.''',
            ),
          ],
        ),
      ],
      functions: [
        AiFunction(
          name: 'update_ingredients',
          description:
              'Updates the ingredient list based on voice input. Only delete items when explicitly told to do so.',
          parameters: {
            'type': 'object',
            'properties': {
              'ingredients': {
                'type': 'array',
                'items': {
                  'type': 'object',
                  'properties': {
                    'name': {'type': 'string'},
                    'count': {'type': 'number'},
                    'unit': {'type': 'string'},
                  },
                  'required': ['name', 'count', 'unit'],
                },
              },
            },
            'required': ['ingredients'],
          },
        ),
      ],
      functionCall: {'name': 'update_ingredients'},
      maxTokens: 1000,
    );

    try {
      final response = await _makeApiCall(requestBody, user.apiKey!);
      if (response != null) {
        final functionCall = response['choices'][0]['message']['function_call'];
        final arguments = jsonDecode(functionCall['arguments']);

        final existingIngredients = await isar.ingredients.where().findAll();

        return await isar.writeTxn(() async {
          final ingredients = <StorageIngredient>[];

          for (var ingredientData in arguments['ingredients']) {
            final ingredient = await _findOrCreateIngredient(
                ingredientData, existingIngredients, isar);

            final storageIngredient = StorageIngredient()
              ..count = ingredientData['count'].toDouble();
            await isar.storageIngredients.put(storageIngredient);

            storageIngredient.ingredient.value = ingredient;
            await storageIngredient.ingredient.save();

            ingredients.add(storageIngredient);
          }

          return ingredients;
        });
      }
      return null;
    } catch (e) {
      developer.log('Exception: $e', name: 'OpenAI');
      return null;
    }
  }
}
