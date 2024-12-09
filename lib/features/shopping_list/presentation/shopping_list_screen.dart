import 'package:flutter/material.dart';
import 'package:mealmaster/features/shopping_list/domain/shopping_list_repository.dart';
import 'package:mealmaster/features/shopping_list/presentation/widgets/shopping_list_grid.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class ShoppingListItem {
  int? count;
  String name;
  ShoppingListItem({required this.count, required this.name});
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  ShoppingListRepository repo = DemoShoppingListRepository();
  late Future<List<ShoppingListItem>> shoppingList = repo.getShoppingList();
  late Future<List<ShoppingListItem>> recentShoppingList =
      repo.getRecentShoppingList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child:
                shoppingListGrid(shoppingList, true, (ShoppingListItem item) {
              repo.removeItemFromShoppingList(item);
              setState(() {});
            }, () {
              setState(() {});
            }),
          ),
          ExpansionTile(
            title: Text("Vorherige Einkäufe"),
            children: [
              SizedBox(
                height: 200,
                child: shoppingListGrid(recentShoppingList, false,
                    (ShoppingListItem item) {
                  repo.addRecentItemToShoppingList(item);
                  setState(() {});
                }, () {
                  setState(() {});
                }),
              )
            ],
          ),
        ],
      ),
    );
  }
}
