import 'package:flutter/material.dart';

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
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: ShoppingListGrid(
                hasAddButton: true,
                onClick: () {},
                callBack: () {},
                shoppingList: shoppingList),
          ),
          ExpansionTile(
            title: Text("Vorherige Einkäufe"),
            children: [
              SizedBox(
                height: 200,
                child: ShoppingListGrid(
                    hasAddButton: false,
                    onClick: () {},
                    callBack: () {},
                    shoppingList: []),
              )
            ],
          ),
        ],
      ),
    );
  }
}
