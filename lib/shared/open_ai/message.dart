import 'content.dart';

class Message {
  final String role;
  final List<Content> content;

  Message({required this.role, required this.content});

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content.map((c) => c.toJson()).toList(),
      };
}
