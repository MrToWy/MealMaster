import 'package:flutter/material.dart';
import 'package:mealmaster/features/home/presentation/controller/edit_mode_controller.dart';
import 'package:mealmaster/features/recipes/domain/recipe.dart';
import 'package:provider/provider.dart';

class RecipeListTile extends StatelessWidget {
  final Recipe recipe;
  final int index;

  const RecipeListTile({super.key, required this.recipe, required this.index});

  @override
  Widget build(BuildContext context) {
    final isEditMode = context.watch<EditModeProvider>().inEditMode;
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: ListTile(
          key: ValueKey(recipe.id),
          selectedTileColor: Colors.green,
          title: Text(
            'Recipe ${recipe.id}',
            style: const TextStyle(
                fontWeight: FontWeight.w400, color: Colors.black, fontSize: 22),
          ),
          subtitle: Row(
            children: [
              Text(
                '${recipe.cookingDuration} min  -  ',
                style: const TextStyle(color: Colors.black),
              ),
              DifficultyIndicator(difficulty: recipe.difficulty)
            ],
          ),
          trailing: isEditMode
              ? ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle,
                      color: Colors.black, size: 30),
                )
              : const Icon(Icons.assignment, color: Colors.black, size: 30),
        ),
      ),
    );
  }
}

class DifficultyIndicator extends StatelessWidget {
  final int difficulty;

  const DifficultyIndicator({super.key, required this.difficulty})
      : assert(difficulty >= 1 && difficulty <= 3);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Icon(
          Icons.restaurant,
          color: index < difficulty ? Colors.black : Colors.grey,
          size: 15,
        );
      }),
    );
  }
}
