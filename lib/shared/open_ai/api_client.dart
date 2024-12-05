import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:mealmaster/shared/open_ai/request_body.dart';

import '../../db/user.dart';

class ApiClient {
  static Future<Map<String, dynamic>?> generateMealPlan(
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
                value:
                    'Analyse the ingredients inside the fridge and generate a meal plan for 5 days'),
            ...images.map((image) => Content(
                  type: 'image_url',
                  value: {'url': "data:image/png;base64," + image},
                )),
          ],
        ),
      ],
      functions: [
        AiFunction(
          name: 'generate_meal_plan',
          description: 'Generates a meal plan with recipes in JSON format',
          parameters: {
            'type': 'object',
            'properties': {
              'startDate': {
                'type': 'string',
                'format': 'date',
                'description': 'Start date of the meal plan (today)'
              },
              'endDate': {
                'type': 'string',
                'format': 'date',
                'description': 'End date of the meal plan (5 days from today)'
              },
              'entries': {
                'type': 'array',
                'description': 'Daily meal plan entries',
                'items': {
                  'type': 'object',
                  'properties': {
                    'day': {
                      'type': 'string',
                      'format': 'date',
                      'description': 'Date for this meal plan entry'
                    },
                    'recipe': {
                      'type': 'object',
                      'properties': {
                        'title': {
                          'type': 'string',
                          'description': 'Title of the recipe'
                        },
                        'cookingDuration': {
                          'type': 'integer',
                          'description': 'Cooking duration in minutes'
                        },
                        'difficulty': {
                          'type': 'integer',
                          'minimum': 1,
                          'maximum': 3,
                          'description': 'Difficulty level (1-3)'
                        },
                        'ingredients': {
                          'type': 'array',
                          'description': 'List of ingredients with quantities',
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
                            },
                            'required': ['name', 'quantity'],
                          },
                        },
                        'steps': {
                          'type': 'array',
                          'description':
                              'Step-by-step instructions for the recipe',
                          'items': {
                            'type': 'object',
                            'properties': {
                              'orderPosition': {
                                'type': 'integer',
                                'description': 'Order position of the step'
                              },
                              'description': {
                                'type': 'string',
                                'description': 'Description of the step'
                              },
                            },
                            'required': ['orderPosition', 'description'],
                          },
                        },
                      },
                      'required': [
                        'title',
                        'cookingDuration',
                        'difficulty',
                        'ingredients',
                        'steps'
                      ],
                    },
                  },
                  'required': ['day', 'recipe'],
                },
              },
            },
            'required': ['startDate', 'endDate', 'entries'],
          },
        ),
      ],
      functionCall: {'name': 'generate_meal_plan'},
      maxTokens: 300,
    );

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${user.apiKey!}',
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
