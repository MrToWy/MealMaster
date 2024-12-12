import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/widgets/base_scaffold.dart';
import '../../../common/widgets/info_dialog_button.dart';
import '../../../db/ingredient.dart';
import '../../../db/storage_ingredient.dart';
import 'validate_items_screen.dart';

class NewPlanScreen extends StatefulWidget {
  const NewPlanScreen({super.key});

  @override
  State<NewPlanScreen> createState() => _NewPlanScreenState();
}

class _NewPlanScreenState extends State<NewPlanScreen> {
  final ImagePicker _picker = ImagePicker();

  // TODO: Remove this method and replace it with actual data
  List<StorageIngredient> getTestData() {
    final Ingredient ingredient = Ingredient()
      ..name = "Eier"
      ..unit = "Stück";

    final StorageIngredient storageIngredient = StorageIngredient()
      ..count = 3
      ..ingredient.value = ingredient;

    final Ingredient ingredient2 = Ingredient()
      ..name = "Milch"
      ..unit = "ml";

    final StorageIngredient storageIngredient2 = StorageIngredient()
      ..count = 200
      ..ingredient.value = ingredient2;

    return [storageIngredient, storageIngredient2];
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final int numberOfCards = 5;

    return BaseScaffold(
      title: 'Neuer Plan',
      hasBackButton: true,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Zeige uns deine Vorräte",
                      style: textTheme.titleLarge,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(width: 20),
                    InfoDialogButton(
                      infoText:
                          "Erstelle Fotos von deinen Vorräten, wie zum Beispiel deinem Kühlschrank oder Vorratsschrank, und MealMaster erstellt dir einen passenden Wochenplan.",
                      title: "Zeige uns deine Vorräte",
                    )
                  ],
                ),
                // TODO: Replace cards with actual images
                SizedBox(
                  height: 400,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 1,
                    ),
                    itemCount: numberOfCards,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 130,
                        width: 130,
                        child: Card.filled(),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
                FilledButton.icon(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    var response =
                        await _picker.pickImage(source: ImageSource.gallery);
                    print(response);
                  },
                  label: Text("Vorräte hinzufügen"),
                ),
              ],
            ),
            FilledButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ValidateItemsScreen(
                    ingredients: getTestData(),
                  );
                }));
              },
              child: Text("Weiter"),
            ),
          ],
        ),
      ),
    );
  }
}
