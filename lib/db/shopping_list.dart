import 'package:isar/isar.dart';

import 'base/db_entry.dart';
import 'shopping_list_entry.dart';

part 'shopping_list.g.dart';

@collection
class ShoppingList extends DbEntry {
  @Backlink(to: 'shoppingList')
  final entries = IsarLinks<ShoppingListEntry>();
}
