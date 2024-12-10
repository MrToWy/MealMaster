import 'package:flutter/material.dart';

enum DietLabel {
  noDiet("Keine Besonderheiten"),
  halal("Halal"),
  kosher("Kosher"),
  vegan("Vegan"),
  vegetarian("Vegetarisch");

  const DietLabel(this.label);
  final String label;
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController dietController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "MealMe",
              textScaler: TextScaler.linear(2),
            ),
            TextField(
              decoration: InputDecoration(hintText: "Dein Name"),
            ),
            TextField(
              decoration: InputDecoration(hintText: "Gewicht"),
            ),
            DropdownMenu(
                initialSelection: DietLabel.noDiet,
                controller: dietController,
                label: const Text("Ernährungsform"),
                dropdownMenuEntries: DietLabel.values
                    .map<DropdownMenuEntry<DietLabel>>((DietLabel diet) {
                  return DropdownMenuEntry<DietLabel>(
                      value: diet, label: diet.label);
                }).toList()),
          ],
        ),
      ),
    );
  }
}
