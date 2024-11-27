import 'package:isar/isar.dart';
import 'package:mealmaster/db/allergy.dart';
import 'package:mealmaster/db/base/db_entry.dart';

import 'diet.dart';

part 'user.g.dart';

@collection
class User extends DbEntry {
  String? name;

  double? weight;

  double? size;

  @Backlink(to: 'user')
  final diets = IsarLinks<Diet>();

  @Backlink(to: 'user')
  final allergies = IsarLinks<Allergy>();
}
