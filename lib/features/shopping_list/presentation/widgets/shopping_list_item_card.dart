import 'package:flutter/material.dart';
import 'package:mealmaster/features/shopping_list/domain/shopping_list_repository.dart';
import 'package:mealmaster/features/shopping_list/presentation/shopping_list_screen.dart';
import 'package:mealmaster/features/shopping_list/presentation/widgets/shopping_list_item_text_input.dart';

Widget shoppingListItemCard(
    context, final ShoppingListItem item, Function onClick, Function callback) {
  return Card.filled(
    child: ListTile(
      title: Text(item.name),
      subtitle: Text("${item.count}"),
      onTap: () {
        onClick(item);
      },
      onLongPress: () {
        editShoppingListItemDialog(context, item, callback);
      },
    ),
  );
}

Future editShoppingListItemDialog(
    context, ShoppingListItem item, Function callback) async {
  ShoppingListRepository repo = DemoShoppingListRepository();
  TextEditingController nameController = TextEditingController(text: item.name);
  TextEditingController countController =
      TextEditingController(text: item.count.toString());

  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Item bearbeiten"),
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
                    repo.editShoppingListItem(item);
                    callback();
                    Navigator.of(context).pop();
                  },
                  child: Text("Speichern"))
            ],
          ));
}
