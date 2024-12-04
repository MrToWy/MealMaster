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

class Message {
  final String role;
  final List<Content> content;

  Message({required this.role, required this.content});

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content.map((c) => c.toJson()).toList(),
      };
}

class Content {
  final String type;
  final dynamic value;

  Content({required this.type, required this.value});

  Map<String, dynamic> toJson() => {
        'type': type,
        type: value,
      };
}

class AiFunction {
  final String name;
  final String description;
  final Map<String, dynamic> parameters;

  AiFunction(
      {required this.name,
      required this.description,
      required this.parameters});

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'parameters': parameters,
      };
}
