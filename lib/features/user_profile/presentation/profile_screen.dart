import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealmaster/common/widgets/loading_button.dart';
import 'package:mealmaster/features/user_profile/data/user_repository.dart';
import 'package:mealmaster/features/user_profile/domain/allergies_enum.dart';
import 'package:mealmaster/features/user_profile/domain/diet_enum.dart';
import 'package:mealmaster/features/user_profile/domain/macros_enum.dart';
import 'package:mealmaster/features/user_profile/domain/user.dart';
import 'package:mealmaster/features/user_profile/presentation/widgets/category_chip_list.dart';

class ProfileScreen extends StatefulWidget {
  final bool firstTime;
  const ProfileScreen({this.firstTime = false, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserRepository userRepo = UserRepository();
  final TextEditingController dietController = TextEditingController();
  final GlobalKey<CategoryChipListState> macroChipWidgetKey = GlobalKey();
  final GlobalKey<CategoryChipListState> allergyChipWidgetKey = GlobalKey();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userWeightController = TextEditingController();
  TextEditingController apiKey = TextEditingController();
  bool loading = true;
  bool hasNoUser = true;

  @override
  void initState() {
    userRepo.getUserRepresentation().then((user) {
      if (user == null) {
        setState(() {
          loading = false;
        });
        return;
      }

      setState(() {
        hasNoUser = false;
        userNameController.value =
            userNameController.value.copyWith(text: user.name);
        userWeightController.value =
            userWeightController.value.copyWith(text: user.weight);
        loading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          allergyChipWidgetKey.currentState?.set.addAll(user.allergies);
        });
      });
    });

    super.initState();
  }

  String testText = "";
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(child: LoadingButton(text: "Loading User"));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: userNameController,
              decoration: InputDecoration(hintText: "Dein Name"),
            ),
            TextField(
              controller: userWeightController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(hintText: "Gewicht"),
            ),
            DropdownMenu(
                initialSelection: DietEnum.noDiet,
                controller: dietController,
                label: const Text("Ernährungsform"),
                dropdownMenuEntries: DietEnum.values
                    .map<DropdownMenuEntry<DietEnum>>((DietEnum diet) {
                  return DropdownMenuEntry<DietEnum>(
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
            if (hasNoUser)
              Column(
                children: [
                  TextField(
                    controller: apiKey,
                    decoration: InputDecoration(hintText: "Dein API-Key"),
                  ),
                  TextButton(
                      onPressed: () {
                        if (userNameController.value.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Das Namen Feld darf nicht leer sein")));
                          return;
                        }
                        userRepo.createUser(
                            userNameController.text, userWeightController.text);
                      },
                      child: Text("Nutzer erstellen"))
                ],
              )
            else
              TextButton(
                  onPressed: () {
                    userRepo.saveUserData(
                        userNameController.text,
                        userWeightController.text,
                        allergyChipWidgetKey.currentState!.set
                            .cast<AllergiesEnum>());
                  },
                  child: Text("Speichern"))
          ],
        ),
      ),
    );
  }
}
