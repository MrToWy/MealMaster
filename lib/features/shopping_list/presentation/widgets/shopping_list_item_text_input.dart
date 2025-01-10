import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShoppingListItemTextInput extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController countController;

  const ShoppingListItemTextInput(
      {super.key, required this.nameController, required this.countController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
                hintText: "Name des Produktes", labelText: "Name"),
          ),
          SizedBox(height: 20),
          TextField(
            controller: countController,
            decoration: InputDecoration(
                hintText: "Bitte gib eine Menge an", labelText: "Menge"),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          )
        ],
      ),
    );
  }
}
