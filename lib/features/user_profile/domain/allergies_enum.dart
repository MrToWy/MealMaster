import 'package:mealmaster/features/user_profile/domain/enum_label.dart';

enum AllergiesEnum implements EnumLabel {
  nut("Nuss", "nut"),
  gluten("Gluten", "gluten"),
  soy("Soya", "soy"),
  lactose("Lactose", "lactose"),
  egg("Ei", "egg");

  const AllergiesEnum(this.label, this.key);
  @override
  final String label;
  final String key;
}
