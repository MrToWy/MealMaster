import 'package:flutter/material.dart';
import 'package:mealmaster/db/shopping_list_entry.dart';
import 'package:mealmaster/features/shopping_list/presentation/widgets/shopping_list_item_text_input.dart';

Widget shoppingListItemCard(context, final ShoppingListEntry item,
    Function onClick, Function callback) {
  return Card.filled(
    child: ListTile(
      title: Text(item.ingredient.value?.name ?? ''),
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
    context, ShoppingListEntry item, Function callback) async {
  TextEditingController nameController =
      TextEditingController(text: item.ingredient.value?.name);
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
                    // TODO: update item
                    callback();
                    Navigator.of(context).pop();
                  },
                  child: Text("Speichern"))
            ],
          ));
}
