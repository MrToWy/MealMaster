import 'package:flutter/material.dart';

class DifficultyIndicator extends StatelessWidget {
  final int difficulty;
  final double size;

  const DifficultyIndicator(
      {super.key, required this.difficulty, this.size = 15})
      : assert(difficulty >= 1 && difficulty <= 3);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Icon(
          Icons.restaurant,
          color: index < difficulty
              ? theme.colorScheme.onSurface
              : theme.disabledColor,
          size: size,
        );
      }),
    );
  }
}
