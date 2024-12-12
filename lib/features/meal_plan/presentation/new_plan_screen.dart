import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/widgets/base_scaffold.dart';
import '../../../common/widgets/info_dialog_button.dart';
import '../../../db/ingredient.dart';
import '../../../db/storage_ingredient.dart';
import '../../../shared/open_ai/api_client.dart';
import 'validate_items_screen.dart';

class NewPlanScreen extends StatefulWidget {
  const NewPlanScreen({super.key});

  @override
  State<NewPlanScreen> createState() => _NewPlanScreenState();
}

class _NewPlanScreenState extends State<NewPlanScreen> {
  final List<String> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndConvertImage() async {
    final XFile? response =
    await _picker.pickImage(source: ImageSource.gallery);

    if (response != null) {
      Uint8List bytes = await response.readAsBytes();
      String base64Image = base64Encode(bytes);

      setState(() {
        _images.add(base64Image);
      });
    } else {
      print('Kein Bild ausgewählt.');
    }
  }

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
    final textTheme = Theme
        .of(context)
        .textTheme;

    return BaseScaffold(
      title: 'Neuer Plan',
      hasBackButton: true,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
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
                  Flexible(
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 1,
                      ),
                      itemCount: _images.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: MemoryImage(base64Decode(_images[index])),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  FilledButton.icon(
                    icon: Icon(Icons.add),
                    onPressed: () async {
                      await pickAndConvertImage();
                    },
                    label: Text("Vorräte hinzufügen"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            FilledButton(
              onPressed: () async {
                await ApiClient.generateStorageIngredients(_images, user, isar)
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
