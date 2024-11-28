class Recipe {
  final int id;
  final bool hasAllIngredients;
  final int cookingDuration;
  final int difficulty;
  Recipe({
    required this.id,
    required this.hasAllIngredients,
    required this.cookingDuration,
    required this.difficulty,
  });
}
