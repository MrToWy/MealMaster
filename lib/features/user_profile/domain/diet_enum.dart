import 'package:mealmaster/features/user_profile/domain/enum_label.dart';

enum DietEnum implements EnumLabel {
  noDiet("Keine Besonderheiten"),
  halal("Halal"),
  kosher("Kosher"),
  vegan("Vegan"),
  vegetarian("Vegetarisch");

  @override
  final String label;
  const DietEnum(this.label);
}
