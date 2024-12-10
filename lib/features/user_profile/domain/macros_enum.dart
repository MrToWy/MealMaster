import 'package:mealmaster/features/user_profile/domain/enum_label.dart';

enum MacrosEnum implements EnumLabel {
  lowCarb("Low Carb"),
  lowFat("Low Fat"),
  highProtein("High Protein"),
  hightCarb("High Carb");

  const MacrosEnum(this.label);
  final String label;
}
