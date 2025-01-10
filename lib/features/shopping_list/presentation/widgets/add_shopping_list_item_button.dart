import 'package:flutter/material.dart';

class AddShoppingListItemButton extends StatelessWidget {
  const AddShoppingListItemButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
        child: IconButton(
            onPressed: () {
              //TODO: Implement onPressed
            },
            icon: Icon(Icons.add)));
  }
}
