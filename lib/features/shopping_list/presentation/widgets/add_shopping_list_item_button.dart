import 'package:flutter/material.dart';
import 'package:mealmaster/features/shopping_list/domain/shopping_list_repository.dart';
import 'package:mealmaster/features/shopping_list/presentation/shopping_list_screen.dart';
import 'package:mealmaster/features/shopping_list/presentation/widgets/shopping_list_item_text_input.dart';

Widget addShoppingListItemButton(context, Function callback) {
  return Card.filled(
      child: IconButton(
          onPressed: () {
            addItemToShoppingListDialog(context, callback);
          },
          icon: Icon(Icons.add)));
}

Future addItemToShoppingListDialog(context, Function callback) async {
  ShoppingListRepository repo = DemoShoppingListRepository();
  TextEditingController nameController = TextEditingController();
  TextEditingController countController = TextEditingController();

  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Neues Item erstellen"),
            icon: Icon(Icons.add),
            content: shoppingListItemTextInput(nameController, countController),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Abbrechen")),
              TextButton(
                  onPressed: () {
                    String name = nameController.text;
                    var count = int.tryParse(countController.text);
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Bitte gib einen Namen ein")));
                      return;
                    }
                    if (count == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Bitte gib eine Menge an")));
                      return;
                    }
                    repo.addItemToShoppingList(
                        ShoppingListItem(count: count, name: name));
                    callback();
                    Navigator.of(context).pop();
                  },
                  child: Text("Hinzufügen"))
            ],
          ));
}
