import 'ai_function.dart';
import 'message.dart';

class RequestBody {
  final String model;
  final List<Message> messages;
  final List<AiFunction> functions;
  final Map<String, String> functionCall;
  final int maxTokens;

  RequestBody({
    required this.model,
    required this.messages,
    required this.functions,
    required this.functionCall,
    required this.maxTokens,
  });

  Map<String, dynamic> toJson() => {
        'model': model,
        'messages': messages.map((m) => m.toJson()).toList(),
        'functions': functions.map((f) => f.toJson()).toList(),
        'function_call': functionCall,
        'max_tokens': maxTokens,
      };
}
