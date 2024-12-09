import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'request_body.dart';
import '../../db/ingredient.dart';
import '../../db/meal_plan_entry.dart';
import '../../db/recipe_ingredient.dart';
import '../../db/user.dart';
import '../../db/storage_ingredient.dart';
import '../../db/meal_plan.dart';
import '../../db/recipe.dart';
import '../../db/recipe_step.dart';
import 'package:isar/isar.dart';

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
      List<String> images, User user, Isar isar) async {
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
                  'Analyze these images and identify all ingredients with their approximate quantities.',
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
                    'quantity': {
                      'type': 'number',
                      'description': 'Quantity of the ingredient'
                    },
                    'unit': {
                      'type': 'string',
                      'description': 'Unit of measurement'
                    },
                  },
                  'required': ['name', 'quantity', 'unit'],
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
              ..count = ingredientData['quantity'].toDouble();
            await isar.storageIngredients.put(storageIngredient);

            storageIngredient.ingredient.add(ingredient);
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
                  'Generate a 5-day meal plan using these ingredients: ${ingredients.map((i) => "${i.ingredient.first.name}: ${i.count} ${i.ingredient.first.unit}").join(", ")}',
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
                                  'quantity': {
                                    'type': 'number',
                                    'description': 'Amount needed'
                                  },
                                  'unit': {
                                    'type': 'string',
                                    'description': 'Unit of measurement'
                                  }
                                },
                                'required': ['name', 'quantity', 'unit']
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

        MealPlan mealPlan = await isar.writeTxn(() async {
          final mealPlan = MealPlan()
            ..startDate = DateTime.now()
            ..endDate = DateTime.now().add(Duration(days: 5));
          isar.mealPlans.put(mealPlan);

          for (var entryData in arguments['mealPlan']['entries']) {
            final mealPlanEntry = MealPlanEntry()
              ..day = DateTime.now()
                  .add(Duration(days: entryData['dayNumber'] - 1));

            final recipeData = entryData['recipe'];
            final recipe = Recipe()
              ..title = recipeData['name']
              ..description = recipeData['description']
              ..cookingDuration = recipeData['steps'].fold<int>(
                  0, (int sum, dynamic step) => sum + step['duration'] as int);

            await isar.mealPlanEntrys.put(mealPlanEntry);
            await isar.recipes.put(recipe);
            mealPlanEntry.recipe.add(recipe);
            await mealPlanEntry.recipe.save();
            mealPlanEntry.mealPlan.add(mealPlan);
            await mealPlanEntry.mealPlan.save();

            for (var ingredientData in recipeData['ingredients']) {
              final ingredient = await _findOrCreateIngredient(
                  ingredientData, existingIngredients, isar);

              final recipeIngredient = RecipeIngredient()
                ..count = ingredientData['quantity'].toDouble();

              await isar.recipeIngredients.put(recipeIngredient);

              recipeIngredient.recipe.add(recipe);
              await recipeIngredient.recipe.save();
              recipeIngredient.ingredients.add(ingredient);
              await recipeIngredient.ingredients.save();
            }

            for (var stepData in recipeData['steps']) {
              final recipeStep = RecipeStep()
                ..orderPosition = stepData['stepNumber']
                ..description = stepData['instruction'];

              await isar.recipeSteps.put(recipeStep);
              recipe.steps.add(recipeStep);
            }
            await recipe.steps.save();
          }

          return mealPlan;
        });

        return mealPlan;
      }
      return null;
    } catch (e) {
      developer.log('Exception: $e', name: 'OpenAI');
      return null;
    }
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
}
