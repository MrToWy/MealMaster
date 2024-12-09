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