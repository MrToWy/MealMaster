import 'package:isar/isar.dart';

part 'User.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement; // Für auto-increment kannst du auch id = null zuweisen

  String? name;

  double? weight;

  double? size;
}