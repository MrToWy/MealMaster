import 'package:flutter/material.dart';

class NoMealPlanScreen extends StatelessWidget {
  const NoMealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;

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
            color: colorTheme.primary,
          ),
          SizedBox(height: 20.0),
          Text(
            'Kein MealPlan gefunden',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Erstelle jetzt deinen ersten MealPlan!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
            ),
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
