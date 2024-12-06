import 'package:flutter/material.dart';
import 'package:mealmaster/features/shopping_list/presentation/shopping_list_screen.dart';
import 'package:mealmaster/features/shopping_list/presentation/widgets/add_shopping_list_item_button.dart';
import 'package:mealmaster/features/shopping_list/presentation/widgets/shopping_list_item_card.dart';

Widget shoppingListGrid(Future<List<ShoppingListItem>> futureList,
    bool hasAddButton, Function onClick, Function callBack) {
  int startIndex = hasAddButton ? 1 : 0;
  return FutureBuilder(
      future: futureList,
      builder: (context, list) {
        if (list.hasData == false) {
          return Container();
        }
        return GridView.builder(
            itemCount: startIndex + list.data!.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, index) {
              if (index == 0 && hasAddButton) {
                return addShoppingListItemButton(context, callBack);
              }
              return shoppingListItemCard(
                  context, list.data![index - startIndex], onClick, callBack);
            });
      });
}
