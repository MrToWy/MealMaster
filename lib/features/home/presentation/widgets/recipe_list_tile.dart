import 'package:flutter/material.dart';
import 'package:mealmaster/features/home/presentation/controller/edit_mode_controller.dart';
import 'package:mealmaster/features/home/presentation/widgets/difficulty_indicator.dart';
import 'package:mealmaster/features/recipes/domain/recipe.dart';
import 'package:provider/provider.dart';

import '../../../recipes/presentation/recipe_screen.dart';

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
              : IconButton(
                  icon: const Icon(Icons.assignment),
                  iconSize: 30,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecipeScreen(id: recipe.id))),
                ),
        ),
      ),
    );
  }
}
