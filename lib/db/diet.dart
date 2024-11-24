import 'package:isar/isar.dart';
import 'package:mealmaster/db/user.dart';

import 'db_entry.dart';

part 'diet.g.dart';

@collection
class Diet extends DbEntry {
  String? name;

  final user = IsarLinks<User>();
}