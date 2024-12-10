import 'package:flutter/material.dart';
import 'package:mealmaster/features/user_profile/domain/allergies_enum.dart';
import 'package:mealmaster/features/user_profile/domain/diet_label.dart';
import 'package:mealmaster/features/user_profile/domain/macros_enum.dart';
import 'package:mealmaster/features/user_profile/presentation/widgets/category_chip_list.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController dietController = TextEditingController();
  Set<AllergiesEnum> allergies = <AllergiesEnum>{};
  final GlobalKey<CategoryChipListState> macroChipWidgetKey = GlobalKey();
  final GlobalKey<CategoryChipListState> allergyChipWidgetKey = GlobalKey();

  String testText = "";
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
            CategoryChipList(
                key: allergyChipWidgetKey,
                title: "Allergien/Unverträglichkeiten",
                category: AllergiesEnum.values),
            CategoryChipList(
                key: macroChipWidgetKey,
                title: "Macros",
                category: MacrosEnum.values),
            TextButton(
                onPressed: () {
                  setState(() {
                    testText =
                        macroChipWidgetKey.currentState!.set.length.toString();
                  });
                },
                child: Text("Speichern"))
          ],
        ),
      ),
    );
  }
}
