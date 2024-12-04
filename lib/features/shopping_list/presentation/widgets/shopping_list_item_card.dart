import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealmaster/features/shopping_list/domain/shopping_list_repository.dart';
import 'package:mealmaster/features/shopping_list/presentation/shopping_list_screen.dart';

Widget shoppingListItemCard(
    context, final ShoppingListItem item, Function onClick, Function callback) {
  return Card(
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
            content: SizedBox(
              height: 200,
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: "Name des Produktes", labelText: "Name"),
                  ),
                  TextField(
                    controller: countController,
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
                    String name = nameController.text;
                    var count = int.tryParse(countController.text);
                    if (name.isEmpty) {
                      //TODO: add some error Message
                      return;
                    }
                    if (count == null) {
                      //TODO: add some error Message
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
