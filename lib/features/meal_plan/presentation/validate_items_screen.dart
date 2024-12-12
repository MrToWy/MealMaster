import 'package:flutter/material.dart';
import '../../user_profile/data/user_repository.dart';
import '../../../shared/open_ai/api_client.dart';

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
                "Folgende Zutaten wurden erkannt:",
                style: textTheme.titleLarge,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    final storageIngredient = ingredients[index];
                    return DetectedIngredient(
                      name: storageIngredient.ingredient.value?.name ?? '',
                      count: storageIngredient.count ?? 0.0,
                      unit: storageIngredient.ingredient.value?.unit ?? '',
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    IconButton(
                        onPressed: () {}, iconSize: 40, icon: Icon(Icons.mic)),
                    Text('Weitere Vorräte hinzufügen'),
                  ],
                ),
              ),
              SizedBox(height: 60),
              Center(
                child: FilledButton.icon(
                  icon: Icon(Icons.check),
                  onPressed: () async {
                    await ApiClient.generateMealPlan(ingredients, await UserRepository().getUser() , await UserRepository().isarInstance);
                  },
                  label: Text('MealPlan erstellen'),
                ),
              ),
            ])));
  }
}
