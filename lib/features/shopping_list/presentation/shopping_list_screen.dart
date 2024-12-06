import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:mealmaster/features/shopping_list/domain/shopping_list_repository.dart';
import 'package:mealmaster/features/shopping_list/presentation/widgets/shopping_list_grid.dart';
//TODO: Clean Up and split into seperate Files
//Missing Features add new Items and Change Items

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
          ExpandablePanel(
            header: const Text(
              "vorherige Einkäufe",
            ),
            collapsed: Text("Show More"),
            expanded: SizedBox(
              height: 200,
              child: shoppingListGrid(recentShoppingList, false,
                  (ShoppingListItem item) {
                repo.addRecentItemToShoppingList(item);
                setState(() {});
              }, () {
                setState(() {});
              }),
            ),
          )
        ],
      ),
    );
  }
}
