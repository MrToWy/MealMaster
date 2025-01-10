import 'package:flutter/material.dart';

import '../../../../db/shopping_list_entry.dart';
import 'add_shopping_list_item_button.dart';
import 'shopping_list_item_card.dart';

Widget shoppingListGrid(List<ShoppingListEntry> shoppingList, bool hasAddButton,
    Function onClick, Function callBack) {
  int startIndex = hasAddButton ? 1 : 0;

  if (shoppingList.isEmpty) {
    return Center(
      child: Text("Du hast alles was du brauchst!"),
    );
  }

  return GridView.builder(
      itemCount: startIndex + shoppingList.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        if (index == 0 && hasAddButton) {
          return addShoppingListItemButton(context, callBack);
        }
        return shoppingListItemCard(context,
            shoppingList.elementAt(index - startIndex), onClick, callBack);
      });
}
