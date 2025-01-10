import 'package:flutter/material.dart';

import '../../../../db/shopping_list_entry.dart';
import 'shopping_list_item_text_input.dart';

class ShoppingListItemCard extends StatelessWidget {
  final ShoppingListEntry item;
  final Function onClick;
  final Function callback;

  const ShoppingListItemCard(
      {super.key,
      required this.item,
      required this.onClick,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: ListTile(
        title: Text(item.ingredient.value?.name ?? ''),
        subtitle: Text(
            "${item.count?.toStringAsFixed(0)} ${item.ingredient.value?.unit}"),
        onTap: () {
          onClick(item);
        },
        onLongPress: () {
          editShoppingListItemDialog(context, item, callback);
        },
      ),
    );
  }
}

Future editShoppingListItemDialog(
    context, ShoppingListEntry item, Function callback) async {
  TextEditingController nameController =
      TextEditingController(text: item.ingredient.value?.name);
  TextEditingController countController =
      TextEditingController(text: item.count?.toStringAsFixed(0));

  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Item bearbeiten"),
            icon: Icon(Icons.add),
            content: ShoppingListItemTextInput(
                nameController: nameController,
                countController: countController),
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
