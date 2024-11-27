import 'package:flutter/material.dart';

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

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Neuer Plan",
                    style: textTheme.displayMedium,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Zeige uns deine Vorräte",
                        style: textTheme.titleLarge,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(width: 20),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Zeige uns deine Vorräte"),
                                  content: Text(
                                    "Erstelle Fotos von deinen Vorräten wie zum Beispiel deinem Kühlschrank oder Vorratsschrank und MealMaster erstellt dir einen passenden Wochenplan.",
                                    style: textTheme.bodyLarge,
                                    softWrap: true,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Dialog schließen
                                      },
                                      child: Text("Schließen"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.info_outline))
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
                child:
                Text("Weiter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
