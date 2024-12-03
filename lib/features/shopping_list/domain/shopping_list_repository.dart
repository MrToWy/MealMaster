import 'dart:async';

import 'package:mealmaster/features/shopping_list/presentation/shopping_list_screen.dart';

abstract class ShoppingListRepository {
  Future<List<ShoppingListItem>> getShoppingList();
  Future<List<ShoppingListItem>> getRecentShoppingList();
  addItemToShoppingList(ShoppingListItem item);
  removeItemFromShoppingList(ShoppingListItem item);
  addRecentItemToShoppingList(ShoppingListItem item);
}

class DemoShoppingListRepository implements ShoppingListRepository {
  static final DemoShoppingListRepository _instance =
      DemoShoppingListRepository._internal();

  factory DemoShoppingListRepository() {
    return _instance;
  }
  DemoShoppingListRepository._internal();

  List<ShoppingListItem> testList = [
    ShoppingListItem(count: 3, name: "Eggs"),
    ShoppingListItem(count: 10, name: "Cheese"),
    ShoppingListItem(count: 1, name: "Milk"),
    ShoppingListItem(count: 1, name: "Pizza"),
    ShoppingListItem(count: 2, name: "Paprika")
  ];

  List<ShoppingListItem> boughtList = [];
  @override
  Future<List<ShoppingListItem>> getRecentShoppingList() {
    return Future.value(boughtList);
  }

  @override
  Future<List<ShoppingListItem>> getShoppingList() {
    return Future.value(testList);
  }

  @override
  addItemToShoppingList(ShoppingListItem item) {
    testList.add(item);
  }

  @override
  removeItemFromShoppingList(ShoppingListItem item) {
    testList.remove(item);
    boughtList.add(item);
  }

  @override
  addRecentItemToShoppingList(ShoppingListItem item) {
    boughtList.remove(item);
    testList.add(item);
  }
}
