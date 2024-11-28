import 'package:flutter/material.dart';

class DifficultyIndicator extends StatelessWidget {
  final int difficulty;

  const DifficultyIndicator({super.key, required this.difficulty})
      : assert(difficulty >= 1 && difficulty <= 3);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Icon(
          Icons.restaurant,
          color: index < difficulty ? Colors.black : Colors.grey,
          size: 15,
        );
      }),
    );
  }
}
