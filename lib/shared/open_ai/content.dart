class Content {
  final String type;
  final dynamic value;

  Content({required this.type, required this.value});

  Map<String, dynamic> toJson() => {
    'type': type,
    type: value,
  };
}