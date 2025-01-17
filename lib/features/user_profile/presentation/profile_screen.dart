import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealmaster/common/widgets/loading_button.dart';
import 'package:mealmaster/features/user_profile/data/user_repository.dart';
import 'package:mealmaster/features/user_profile/domain/allergies_enum.dart';
import 'package:mealmaster/features/user_profile/domain/diet_enum.dart';
import 'package:mealmaster/features/user_profile/domain/macros_enum.dart';
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
  DietEnum _selectedDiet = DietEnum.noDiet;

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
        _selectedDiet = user.diets;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          allergyChipWidgetKey.currentState?.set.addAll(user.allergies);
        });
      });
    });

    super.initState();
  }

  void createUserOnClick() {
    if (!validateProfileInput()) {
      return;
    }

    userRepo
        .saveUserData(
            userNameController.text,
            userWeightController.text,
            allergyChipWidgetKey.currentState!.set.cast<AllergiesEnum>(),
            _selectedDiet,
            apiKey: apiKey.text)
        .then((success) {
      if (success) {
        if (context.mounted) {
          Navigator.popAndPushNamed(context, "/navigation");
        }
      } else {
        //error Message
      }
    });
  }

  void saveUserOnClick() {
    if (!validateProfileInput()) {
      return;
    }

    userRepo.saveUserData(
        userNameController.text,
        userWeightController.text,
        allergyChipWidgetKey.currentState!.set.cast<AllergiesEnum>(),
        _selectedDiet);
  }

  bool validateProfileInput() {
    if (userNameController.value.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Das Namen-Feld darf nicht leer sein")));
      return false;
    }
    if (userWeightController.value.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Das Gewichts-Feld darf nicht leer sein")));
      return false;
    }
    if (hasNoUser && apiKey.text == "") {
      //TODO: maybe check key validity
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Bitte gib einen api Key ein")));
      return false;
    }

    return true;
  }

  String testText = "";
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(child: LoadingButton(text: "Loading User"));
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Tastatur schließen
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: userNameController,
                  decoration: InputDecoration(
                      hintText: "Dein Name", label: Text("Name")),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: userWeightController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                      hintText: "Gewicht",
                      suffixText: "Kg",
                      label: Text("Gewicht")),
                ),
                SizedBox(height: 20),
                DropdownMenu(
                    width: double.infinity,
                    initialSelection: _selectedDiet,
                    controller: dietController,
                    onSelected: (diet) {
                      setState(() {
                        _selectedDiet = diet ?? _selectedDiet;
                      });
                    },
                    label: const Text("Ernährungsform"),
                    dropdownMenuEntries: DietEnum.values
                        .map<DropdownMenuEntry<DietEnum>>((DietEnum diet) {
                      return DropdownMenuEntry<DietEnum>(
                          value: diet, label: diet.label);
                    }).toList()),
                SizedBox(height: 20),
                CategoryChipList(
                    key: allergyChipWidgetKey,
                    title: "Allergien/Unverträglichkeiten",
                    category: AllergiesEnum.values),
                SizedBox(height: 20),
                CategoryChipList(
                    key: macroChipWidgetKey,
                    title: "Macros",
                    category: MacrosEnum.values),
                SizedBox(height: 20),
                if (hasNoUser)
                  Column(
                    children: [
                      TextField(
                        controller: apiKey,
                        decoration: InputDecoration(hintText: "Dein API-Key"),
                      ),
                      TextButton(
                          onPressed: createUserOnClick,
                          child: Text("Nutzer erstellen"))
                    ],
                  )
                else
                  FilledButton(
                      onPressed: saveUserOnClick, child: Text("Speichern")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
