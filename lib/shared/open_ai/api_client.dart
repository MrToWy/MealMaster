import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:mealmaster/shared/open_ai/request_body.dart';
import '../../db/ingredient.dart';
import '../../db/meal_plan_entry.dart';
import '../../db/recipe_ingredient.dart';
import '../../db/user.dart';
import '../../db/storage_ingredient.dart';
import '../../db/meal_plan.dart';
import '../../db/recipe.dart';
import '../../db/recipe_step.dart';

class ApiClient {
  static Future<List<StorageIngredient>?> generateStorageIngredients(
      List<String> images, User user) async {
    if (images.isEmpty) {
      developer.log('No images provided', name: 'OpenAI');
      return null;
    }

    if (user.apiKey == null) {
      developer.log('No api key provided', name: 'OpenAI');
      return null;
    }

    final requestBody = RequestBody(
      model: 'gpt-4o',
      messages: [
        Message(
          role: 'user',
          content: [
            Content(
              type: 'text',
              value: 'Analyze these images and identify all ingredients with their approximate quantities.',
            ),
            ...images.map((image) => Content(
                  type: 'image_url',
                  value: {'url': "data:image/png;base64," + image},
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
        
        return (arguments['ingredients'] as List).map((ingredientData) {
          final ingredient = Ingredient()
            ..name = ingredientData['name']
            ..unit = ingredientData['unit'];

          final storageIngredient = StorageIngredient()
            ..count = ingredientData['quantity'].toDouble();
          
          storageIngredient.ingredient.add(ingredient);
          ingredient.storageIngredient.add(storageIngredient);

          return storageIngredient;
        }).toList();
      }
      return null;
    } catch (e) {
      developer.log('Exception: $e', name: 'OpenAI');
      return null;
    }
  }

  static Future<MealPlan?> generateMealPlan(
      List<StorageIngredient> ingredients, User user) async {
    if (ingredients.isEmpty) {
      developer.log('No ingredients provided', name: 'OpenAI');
      return null;
    }

    if (user.apiKey == null) {
      developer.log('No api key provided', name: 'OpenAI');
      return null;
    }

    final requestBody = RequestBody(
      model: 'gpt-4',
      messages: [
        Message(
          role: 'user',
          content: [
            Content(
              type: 'text',
              value: 'Generate a 5-day meal plan using these ingredients: ${ingredients.map((i) => "${i.ingredient.first.name}: ${i.count} ${i.ingredient.first.unit}").join(", ")}',
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
                                'required': ['stepNumber', 'instruction', 'duration']
                              }
                            }
                          },
                          'required': ['name', 'description', 'ingredients', 'steps']
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
      maxTokens: 300,
    );

    try {
      final response = await _makeApiCall(requestBody, user.apiKey!);
      if (response != null) {
        final functionCall = response['choices'][0]['message']['function_call'];
        final arguments = jsonDecode(functionCall['arguments']);
        
        // Create a new MealPlan object
        final mealPlan = MealPlan()
          ..startDate = DateTime.now()
          ..endDate = DateTime.now().add(Duration(days: 5));

        // Parse entries
        for (var entryData in arguments['mealPlan']['entries']) {
          final mealPlanEntry = MealPlanEntry()
            ..day = DateTime.now().add(Duration(days: entryData['dayNumber'] - 1));

          final recipeData = entryData['recipe'];
          final recipe = Recipe()
            ..title = recipeData['name']
            ..description = recipeData['description']
            ..cookingDuration = recipeData['steps'].fold<int>(0, (sum, step) => sum + step['duration']);

          // Parse ingredients
          for (var ingredientData in recipeData['ingredients']) {
            // Create the Ingredient
            // ToDo dont create it when it exists already
            final ingredient = Ingredient()
              ..name = ingredientData['name']
              ..unit = ingredientData['unit'];

            // Create the RecipeIngredient with the count
            final recipeIngredient = RecipeIngredient()
              ..count = ingredientData['quantity'].toDouble();

            // Link everything together
            recipeIngredient.recipe.add(recipe);
            recipeIngredient.ingredients.add(ingredient);
            ingredient.recipeIngredient.add(recipeIngredient);
            recipe.ingredients.add(recipeIngredient);
          }

          // Parse steps
          for (var stepData in recipeData['steps']) {
            final recipeStep = RecipeStep()
              ..orderPosition = stepData['stepNumber']
              ..description = stepData['instruction'];

            recipe.steps.add(recipeStep);
          }

          //mealPlanEntry.recipe.add(recipe); // ToDo: Add link to db class
          mealPlan.entries.add(mealPlanEntry);
        }

        // Save mealPlan to the database
        // await isar.writeTxn((isar) async {
        //   await isar.mealPlans.put(mealPlan);
        // });

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
