import 'package:mealmaster/features/user_profile/domain/enum_label.dart';

enum DietLabel implements EnumLabel {
  noDiet("Keine Besonderheiten"),
  halal("Halal"),
  kosher("Kosher"),
  vegan("Vegan"),
  vegetarian("Vegetarisch");

  // ignore: annotate_overrides
  final String label;
  const DietLabel(this.label);
}
