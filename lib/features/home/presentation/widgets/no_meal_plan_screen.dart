import 'package:flutter/material.dart';

class NoMealPlanScreen extends StatelessWidget {
  const NoMealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
          SizedBox(height: 50.0),
          Icon(
            Icons.fastfood, // Symbol für Essen
            size: 80.0,
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: 20.0),
          Text('Kein MealPlan gefunden', style: theme.textTheme.headlineMedium),
          SizedBox(height: 10.0),
          Text(
            'Erstelle jetzt deinen ersten MealPlan!',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall,
          ),
          SizedBox(height: 30.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/new-plan');
            },
            child: Text(
              'Neuer Plan',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ]));
  }
}
