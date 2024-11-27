import 'package:isar/isar.dart';
import 'package:mealmaster/db/user.dart';

import 'base/db_entry.dart';

part 'allergy.g.dart';

@collection
class Allergy extends DbEntry {
  String? name;

  final user = IsarLinks<User>();
}
