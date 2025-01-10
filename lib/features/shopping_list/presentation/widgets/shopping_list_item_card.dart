import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../db/shopping_list_entry.dart';
import '../../domain/shopping_list_repository.dart';

class ShoppingListItemCard extends StatelessWidget {
  final ShoppingListEntry item;
  final Function onClick;

  const ShoppingListItemCard(
      {super.key,
      required this.item,
      required this.onClick,
      });

  @override
  Widget build(BuildContext context) {
    TextEditingController countController =
        TextEditingController(text: item.count?.toStringAsFixed(0));

    Future<void> updateItem(double count, int id) async {
      final shoppingListRepository = ShoppingListRepository();

      await shoppingListRepository.updateShoppingListEntryById(count, id);
    }

    return Card.filled(
      child: ListTile(
        title: Text(item.ingredient.value?.name ?? ''),
        subtitle: Text(
            "${item.count?.toStringAsFixed(0)} ${item.ingredient.value?.unit}"),
        onTap: () {
          onClick(item);
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title:
                        Text("${item.ingredient.value?.name ?? ''} bearbeiten"),
                    icon: Icon(Icons.edit),
                    content: TextField(
                      controller: countController,
                      decoration: InputDecoration(
                          hintText: "Bitte gib eine Menge an",
                          labelText: "Menge"),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Abbrechen")),
                      TextButton(
                          onPressed: () async {
                            var count = double.tryParse(countController.text);
                            if (count == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Bitte gib eine Menge an")));
                              return;
                            }
                            await updateItem(count, item.id);
                            Navigator.of(context).pop();
                          },
                          child: Text("Speichern"))
                    ],
                  ));
        },
      ),
    );
  }
}
