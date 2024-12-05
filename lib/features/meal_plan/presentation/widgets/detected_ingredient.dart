import 'package:flutter/material.dart';

class DetectedIngredient extends StatelessWidget {
  final String name;
  final double count;
  final String unit;

  const DetectedIngredient(
      {super.key, required this.name, required this.count, required this.unit});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text('${count.toStringAsFixed(0)} $unit'),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {},
      ),
    );
  }
}
