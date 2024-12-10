import 'package:mealmaster/features/user_profile/domain/enum_label.dart';

enum AllergiesEnum implements EnumLabel {
  nut("Nuss"),
  gluten("Gluten");

  const AllergiesEnum(this.label);
  final String label;
}
