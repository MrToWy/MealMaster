import 'package:flutter/material.dart';

import '../../../../db/shopping_list_entry.dart';
import 'add_shopping_list_item_button.dart';
import 'shopping_list_item_card.dart';

class ShoppingListGrid extends StatelessWidget {
  final bool hasAddButton;
  final Function onClick;
  final Function callBack;
  final List<ShoppingListEntry> shoppingList;

  const ShoppingListGrid(
      {super.key,
      required this.hasAddButton,
      required this.onClick,
      required this.callBack,
      required this.shoppingList});

  @override
  Widget build(BuildContext context) {
    int startIndex = hasAddButton ? 1 : 0;

    return GridView.builder(
        itemCount: startIndex + shoppingList.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          if (index == 0 && hasAddButton) {
            return AddShoppingListItemButton();
          }

          return ShoppingListItemCard(
              item: shoppingList.elementAt(index - startIndex),
              onClick: onClick,
              callback: callBack);
        });
  }
}
