import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/shopping_list_repository.dart';

class AddShoppingListItemButton extends StatelessWidget {
  const AddShoppingListItemButton({super.key});

  Future<void> addNewItem(name, count, unit) async {
    final shoppingListRepository = ShoppingListRepository();

    await shoppingListRepository.addShoppingListEntry(name, count, unit);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController countController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController unitController = TextEditingController();

    return Card.filled(
        child: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("Neue Zutat hinzufügen"),
                        icon: Icon(Icons.add),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  hintText: "Bitte gib einen Namen an",
                                  labelText: "Name"),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: countController,
                              decoration: InputDecoration(
                                  hintText: "Bitte gib eine Menge an",
                                  labelText: "Menge"),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: unitController,
                              decoration: InputDecoration(
                                  hintText: "Bitte gib eine Einheit an",
                                  labelText: "Einheit"),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Abbrechen")),
                          TextButton(
                              onPressed: () async {
                                var count =
                                    double.tryParse(countController.text);
                                if (count == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Bitte gib eine Menge an")));
                                  return;
                                }
                                var unit = unitController.text;
                                if (unit == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Bitte gib eine Einheit an")));
                                  return;
                                }
                                var name = nameController.text;
                                if (name == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Bitte gib einen Namen an")));
                                  return;
                                }

                                await addNewItem(name, count, unit);
                                Navigator.of(context).pop();
                              },
                              child: Text("Speichern"))
                        ],
                      ));
            },
            icon: Icon(Icons.add)));
  }
}
