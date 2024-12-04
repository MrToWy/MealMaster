import 'package:flutter/material.dart';

import '../../../common/widgets/base_scaffold.dart';
import '../../../db/storage_ingredient.dart';
import 'widgets/detected_ingredient.dart';

class ValidateItemsScreen extends StatelessWidget {
  final List<StorageIngredient> ingredients;

  const ValidateItemsScreen({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BaseScaffold(
        title: 'Neuer Plan',
        hasBackButton: true,
        child: Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Folgende Zuaten wurden erkannt:",
                style: textTheme.titleLarge,
                textAlign: TextAlign.start,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    final storageIngredient = ingredients[index];
                    return DetectedIngredient(
                      name: storageIngredient.ingredient.single.name ?? '',
                      count: storageIngredient.count.toString(),
                      unit: storageIngredient.ingredient.single.unit ?? '',
                    );
                  },
                ),
              ),
              Center(
                child: FilledButton.icon(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    // TODO: Implement generating meal plan
                  },
                  label: Text('MealPlan erstellen'),
                ),
              ),
            ])));
  }
}
