import 'package:flutter/material.dart';

import '../../../../db/storage_ingredient.dart';

class DetectedIngredient extends StatelessWidget {
  final StorageIngredient storageIngredient;
  final Function delete;

  const DetectedIngredient(
      {super.key, required this.storageIngredient, required this.delete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(storageIngredient.ingredient.value!.name ?? ''),
      subtitle: Text(
          '${storageIngredient.count?.toStringAsFixed(0)} ${storageIngredient.ingredient.value?.unit}'),
      trailing: IconButton(
        icon: Icon(Icons.delete_outline),
        onPressed: () {
          delete(storageIngredient);
        },
      ),
    );
  }
}
