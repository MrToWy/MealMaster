import 'package:flutter/material.dart';
import 'package:mealmaster/common/widgets/base_scaffold.dart';

import '../../../common/widgets/info_dialog_button.dart';

class NewPlanScreen extends StatefulWidget {
  const NewPlanScreen({super.key});

  @override
  State<NewPlanScreen> createState() => _NewPlanScreenState();
}

class _NewPlanScreenState extends State<NewPlanScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final int numberOfCards = 5;

    return BaseScaffold(
      title: 'Neuer Plan',
      hasBackButton: true,
      child: SafeArea(
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
                        crossAxisCount: 2,
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
                    onPressed: () {
                      //TODO: Implement upload images
                    },
                    label: Text("Vorräte hinzufügen"),
                  ),
                ],
              ),
              FilledButton(
                onPressed: null,
                child: Text("Weiter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
