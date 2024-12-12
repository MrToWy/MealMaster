import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

SizedBox shoppingListItemTextInput(TextEditingController nameController,
    TextEditingController countController) {
  return SizedBox(
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
              hintText: "Bitte gib eine Menge an", labelText: "Menge"),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        )
      ],
    ),
  );
}
