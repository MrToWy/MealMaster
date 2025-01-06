import 'package:mealmaster/features/user_profile/domain/allergies_enum.dart';
import 'package:mealmaster/features/user_profile/domain/diet_enum.dart';
import 'package:mealmaster/features/user_profile/domain/macros_enum.dart';

class UserRepresentation {
  Set<AllergiesEnum> allergies = {};
  Set<DietEnum> diets = {};
  Set<MacrosEnum> macros = {};
  final String name;
  final String weight;
  UserRepresentation(
      {required this.name, required this.weight, allergies, diets, macros}) {
    if (allergies != null) {
      this.allergies.addAll(allergies);
    }
    if (diets != null) {
      this.diets.addAll(diets);
    }
    if (macros != null) {
      this.macros.addAll(macros);
    }
  }
}
