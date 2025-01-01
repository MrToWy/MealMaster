import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:mealmaster/features/meal_plan/data/meal_plan_repository.dart';
import 'package:mealmaster/features/storage/data/storage_repositoy.dart';

import '../../db/meal_plan.dart';
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

  /// Analyzes images to detect ingredients and their quantities, storing them in the database.
  ///
  /// [images] List of base64 encoded image strings to analyze
  /// [user] The user making the request, must have a valid API key
  /// [isar] Database instance for storing the results
  ///
  /// Returns a list of [StorageIngredient] objects if successful, null otherwise.
  static Future<List<StorageIngredient>?> generateStorageIngredientsFromImages(
      List<String> images) async {
    final user = await UserRepository().getUser();

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
                  'Analysieren Sie diese Bilder und identifizieren Sie alle Zutaten mit ihren ungefähren Mengenangaben. Antworten Sie immer auf Deutsch, unabhängig von der Anfrage.',
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
        final storageRepository = StorageRepository();

        return storageRepository
            .createStorageIngredientsFromAiResponse(arguments);
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
                  'Erstellen Sie einen 5-Tage-Mahlzeitenplan mit diesen Zutaten. Es dürfen auch andere Zutaten genutzt werden, um nicht jeden Tag ähnliches zu essen. Die genannten Zutaten sollten aber wenn möglich aufgebraucht werden. ${ingredients.map((i) => "${i.ingredient.value?.name}: ${i.count} ${i.ingredient.value?.unit}").join(", ")}. Antworten Sie immer auf Deutsch, unabhängig von der Anfrage.',
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
        final functionCall = response['choices'][0]['message']['function_call'];
        final arguments = jsonDecode(functionCall['arguments']);
        final mealPlanRepository = MealPlanRepository();
        return mealPlanRepository
            .createMealPlanFromAiResponse(arguments['mealPlan']['entries']);
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
        final decodedResponse = utf8.decode(response.bodyBytes);
        return jsonDecode(decodedResponse);
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

  /// Transcribes an audio file to text using OpenAI's Whisper model.
  ///
  /// [filePath] Path to the audio file to transcribe
  ///
  /// Returns the transcribed text if successful, null otherwise.
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
        final decodedResponse = utf8.decode(response.bodyBytes);
        final responseData = jsonDecode(decodedResponse);
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

  /// Updates the list of storage ingredients based on text input describing changes.
  ///
  /// [currentIngredients] The current list of ingredients to update
  /// [text] Description of changes to make to the ingredients list
  ///
  /// Returns an updated list of [StorageIngredient] objects if successful, null otherwise.
  static Future<List<StorageIngredient>?> updateIngredientsFromText(
      List<StorageIngredient> currentIngredients, String text) async {
    final user = await UserRepository().getUser();

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

        final storageRepository = StorageRepository();

        return storageRepository
            .updateStorageIngredientsFromAiResponse(arguments);
      }
      return null;
    } catch (e) {
      developer.log('Exception: $e', name: 'OpenAI');
      return null;
    }
  }
}
