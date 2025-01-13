import 'package:mealmaster/features/user_profile/domain/enum_label.dart';

enum DietEnum implements EnumLabel {
  noDiet("Keine Besonderheiten", "noDiet"),
  halal("Halal", "halal"),
  kosher("Kosher", "kosher"),
  vegan("Vegan", "vegan"),
  vegetarian("Vegetarisch", "vegetarian");

  @override
  final String label;
  final String key;
  const DietEnum(this.label, this.key);
}
