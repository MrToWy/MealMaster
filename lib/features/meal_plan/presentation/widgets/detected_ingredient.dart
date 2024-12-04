import 'package:flutter/material.dart';

class DetectedIngredient extends StatelessWidget {
  final String name;
  final String count;
  final String unit;

  const DetectedIngredient(
      {super.key, required this.name, required this.count, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFF395B64),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                ),
                SizedBox(height: 4),
                Text(
                  '$count $unit',
                ),
              ],
            ),
          ),
          Icon(Icons.edit, color: Colors.white),
        ],
      ),
    );
  }
}
