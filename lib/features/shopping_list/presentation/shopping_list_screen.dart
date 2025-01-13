import 'package:flutter/material.dart';
import 'package:mealmaster/features/shopping_list/controller/shopping_list_provider.dart';
import 'package:provider/provider.dart';

import '../../../db/shopping_list_entry.dart';
import '../domain/shopping_list_repository.dart';
import 'widgets/shopping_list_grid.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<ShoppingListEntry> shoppingList = [];
  List<ShoppingListEntry> previousPurchases = [];

  Future<void> removeItem(ShoppingListEntry entry) async {
    final shoppingListRepository = ShoppingListRepository();
    await shoppingListRepository.removeEntryFromShoppingList(entry.id);
    setState(() {
      previousPurchases.add(entry);
    });
  }

  Future<void> addItem(ShoppingListEntry entry) async {
    final shoppingListRepository = ShoppingListRepository();
    await shoppingListRepository.addEntryToShoppingList(entry);
    setState(() {
      previousPurchases.remove(entry);
    });
  }

  Future<void> getShoppingListEntries() async {
    final shoppingListRepository = ShoppingListRepository();
    List<ShoppingListEntry> shoppingList =
        await shoppingListRepository.getShoppingListEntries();
    setState(() {
      this.shoppingList = shoppingList;
    });
  }

  @override
  void initState() {
    super.initState();
    getShoppingListEntries();
  }

  @override
  Widget build(BuildContext context) {
    final _ = context.watch<ShoppingListProvider>();
    getShoppingListEntries();

    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: ShoppingListGrid(
                hasAddButton: true,
                onClick: removeItem,
                shoppingList: shoppingList),
          ),
          ExpansionTile(
            title: Text("Vorherige Einkäufe"),
            children: [
              SizedBox(
                height: 200,
                child: ShoppingListGrid(
                    hasAddButton: false,
                    onClick: addItem,
                    shoppingList: previousPurchases),
              )
            ],
          ),
        ],
      ),
    );
  }
}
