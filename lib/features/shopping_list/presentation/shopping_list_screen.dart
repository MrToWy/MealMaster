import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealmaster/db/storage_ingredient.dart';
import 'package:mealmaster/features/shopping_list/domain/shopping_list_repository.dart';
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
              }),
            ),
          )
        ],
      ),
    );
  }
}

Widget shoppingListItemCard(final ShoppingListItem item, Function onClick) {
  return Card(
    child: ListTile(
      title: Text(item.name),
      subtitle: Text("${item.count}"),
      onTap: () {
        onClick(item);
      },
      onLongPress: () => {},
    ),
  );
}

Widget addShoppingListItemButton(context) {
  return Card(
      child: IconButton(
          onPressed: () {
            newItemDialog(context);
          },
          icon: Icon(Icons.add)));
}

Widget shoppingListGrid(Future<List<ShoppingListItem>> futureList,
    bool hasAddButton, Function onClick) {
  int startIndex = hasAddButton ? 1 : 0;
  return FutureBuilder(
      future: futureList,
      builder: (context, list) {
        if (list.hasData == false) {
          return Container();
        }
        return GridView.builder(
            itemCount: startIndex + list.data!.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, index) {
              if (index == 0 && hasAddButton) {
                return addShoppingListItemButton(context);
              }
              return shoppingListItemCard(
                  list.data![index - startIndex], onClick);
            });
      });
}

Future newItemDialog(context) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
          title: Text("Neues Item erstellen"),
          icon: Icon(Icons.add),
          content: SizedBox(
            height: 200,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      hintText: "Name des Produktes", labelText: "Name"),
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Bite gib eine Menge an",
                      labelText: "MengenAngabe"),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Abbrechen")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Hinzufügen"))
          ],
        ));
